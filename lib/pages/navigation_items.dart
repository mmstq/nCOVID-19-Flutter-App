import 'dart:math';

import 'package:covid19/api/api_urls.dart';
import 'package:covid19/api/service.dart';
import 'package:covid19/data.dart';
import 'package:covid19/models/image_model.dart';
import 'package:covid19/notifiers/headline_notifier.dart';
import 'package:covid19/notifiers/homescreen_notifier.dart';
import 'package:covid19/pages/about_me.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  HomeNotifier _notesNotifier;
  HeadlineNotifier _headlineNotifier = new HeadlineNotifier();
  FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);
  AnimationController _animationControllerRefresh;
  CurvedAnimation _animationRefresh;
  Animation<double> _tweenRefresh;
  Size screen;

  @override
  void initState() {
    super.initState();

    _animationControllerRefresh =
        AnimationController(duration: Duration(seconds: 20), vsync: this);
    _tweenRefresh =
        Tween<double>(begin: 0, end: 1).animate(_animationControllerRefresh);
    _animationRefresh =
        CurvedAnimation(parent: _tweenRefresh, curve: Curves.linear);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _notesNotifier.getAll('all').then((value) async {
        await Future.delayed(Duration(milliseconds: 300));
        _headlineNotifier.getHeadlines();
      });
    });
  }

  bool _dialog = true;

  @override
  void dispose() {
    super.dispose();
    _animationControllerRefresh.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => service<HomeNotifier>(),
      child: NestedScrollView(headerSliverBuilder: (context, scrolled) {
        return <Widget>[
          SliverAppBar(
            actions: <Widget>[],
            centerTitle: false,
            expandedHeight: screen.height * 0.26,
            floating: true,
            pinned: false,
            forceElevated: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('asset/corona.jpg'))),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Positioned(
                      top: 35,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade400.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4)),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'nCOVID-19 Tracker',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      )
                      /**/,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.indigo.shade400.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            onTap: () {
                              Share.share(
                                  'An android app that shows latest information, stats and news about the COVID-19 pandemic.\nIt also shows Indian states and district wise tally and much more...\nDownload now:\n${ApiURL.apkURL}');
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            child: Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.indigo.shade400.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AboutMe()));
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.indigo.shade400.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4)),
                              child: AnimatedBuilder(
                                animation: _animationRefresh,
                                child: InkWell(
                                  onTap: () {
                                    _notesNotifier.getAll('all');
                                    _animationControllerRefresh.reset();
                                    _animationControllerRefresh.repeat();
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                builder: (context, child) {
                                  return Transform.rotate(
                                      angle:
                                          _animationRefresh.value * pi * 2 * 18,
                                      child: child);
                                },
                              )),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      }, body: Consumer<HomeNotifier>(
        builder: (context, model, child) {
          _notesNotifier = model;
          if (model.state == NoteStates.Done) {
            if (model.updateAvailable && _dialog) {
              Future.delayed(Duration(milliseconds: 300)).then((onValue) {
                _dialog = false;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showUpdateDialog(context);
                    });
              });
            } else {
              if (_dialog && model.images.isNotEmpty)
                Future.delayed(Duration(milliseconds: 300)).then((onValue) {
                  _dialog = false;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final image = Random().nextInt(model.images.length);
                        return showCustomDialog(context, model.images[image]);
                      });
                });
            }
            if (_animationControllerRefresh.isAnimating) {
              _animationControllerRefresh.stop();
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 1,
              ),
              getListItem('Total Cases', model.notes.cases, 'asset/patient.png',
                  Colors.lightBlueAccent.shade400, model),
              getListItem(
                  'Recovered',
                  model.notes.recovered,
                  'asset/wheelchair.png',
                  Colors.lightGreenAccent.shade700,
                  model),
              getListItem('Total Deaths', model.notes.deaths, 'asset/skull.png',
                  Colors.red.shade500, model),
              getListItem('Active', model.notes.active, 'asset/active.png',
                  Colors.orangeAccent.shade700, model),
              SizedBox(
                height: 1,
              ),
            ],
          );
        },
      )),
    );
  }

  Widget getListItem(
      String title, final item, String image, Color color, HomeNotifier model) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: color,
      shadowColor: color,
      child: Container(
        padding: EdgeInsets.all(8),
        width: screen.width * 0.95,
        height: screen.height * 0.14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              image,
              height: screen.height * 0.08,
              fit: BoxFit.fill,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: 5,
                ),
                (model.state == NoteStates.Busy)
                    ? Center(
                        child: Container(
                            padding: EdgeInsets.all(4),
                            height: 25,
                            width: 25,
                            child: Theme(
                              data: ThemeData(accentColor: Colors.white),
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                            )),
                      )
                    : getTotalCount(item)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getTotalCount(final item) {
    return TweenAnimationBuilder(
      curve: Curves.easeInCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500),
      builder: (_, value, child) => Text(
          '${_fmf.copyWith(amount: value * item).output.withoutFractionDigits}',
          style: TextStyle(
              shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1,1))],
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget showCustomDialog(BuildContext context, ImageModel image) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 200),
      child: Dialog(
        backgroundColor: Colors.white,
        elevation: 30,
        child: AspectRatio(
          aspectRatio: image.width / image.height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: CachedNetworkImage(
              imageUrl: image.imageUrl,
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
      curve: Curves.bounceInOut,
      tween: Tween<double>(
        begin: 0,
        end: 2 * pi,
      ),
      builder: (_, value, child) {
        double offset = sin(value);
        return Transform.translate(
          offset: Offset(offset * 20, 0),
          child: child,
        );
      },
    );
  }

  Widget showUpdateDialog(BuildContext context) {
    final style = TextStyle(fontWeight: FontWeight.w400, fontSize: 20);
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 30,
      child: Container(
        height: screen.width * 0.8,
        width: screen.width * 0.6,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 3,
            ),
            Text(
              'Update Available',
              style: style.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacer(
              flex: 2,
            ),
            Image.asset(
              'asset/update.png',
              height: 100,
              width: 100,
            ),
            Spacer(
              flex: 2,
            ),
            Text(
              'Download Now..?',
              style: style,
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.redAccent,
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.lightGreenAccent.shade700,
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (await canLaunch(ApiURL.apkURL)) {
                          Navigator.pop(context);
                          await launch(ApiURL.apkURL);
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Headlines extends StatefulWidget {
  @override
  _HeadlinesState createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  HeadlineNotifier _headlineNotifier;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _headlineNotifier.getHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider<HeadlineNotifier>(
      create: (_) => service<HeadlineNotifier>(),
      child: Scaffold(
        body: Consumer<HeadlineNotifier>(
          builder: (context, headlineModel, child) {
            _headlineNotifier = headlineModel;
            if (headlineModel.state == NoteStates.Busy) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                padding: MediaQuery.of(context)
                    .removePadding(removeTop: true)
                    .padding,
                // ignore: missing_return
                itemCount: headlineModel.headlines.length,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: screen.height * 0.3,
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            headlineModel.headlines[i].urlToImage==null?'':headlineModel.headlines[i].urlToImage,
                            fit: BoxFit.cover,
                            width: screen.width,
                            height: screen.height*0.3,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black38,

                              ),
                              width: screen.width*0.9,
                              child: Text(headlineModel.headlines[i].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return GestureDetector(
                      onTap: () async {
                        final url = headlineModel.headlines[i].url;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        leading: Container(
                          width: screen.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                  headlineModel.headlines[i].urlToImage,
                                scale: 1.7
                              )
                            )
                          ),
                        ),
                        title: Text(headlineModel.headlines[i].title,
                            style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),

                      )
                      );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
