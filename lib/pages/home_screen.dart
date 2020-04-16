import 'dart:math';
import 'dart:typed_data';

import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/notifiers/headline_notifier.dart';
import 'package:COVID19/notifiers/homescreen_notifier.dart';
import 'package:COVID19/pages/about_me.dart';
import 'package:COVID19/pages/all_country_info.dart';
import 'package:COVID19/pages/india_map.dart';
import 'package:COVID19/pages/states_wise_stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeNotifier _notesNotifier;
  HeadlineNotifier _headlineNotifier = new HeadlineNotifier();
  FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);
  AnimationController _animationControllerRefresh;
  CurvedAnimation _animationRefresh;
  Animation<double> _tweenRefresh;
  bool _started = true;
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
    final no = Random().nextInt(Data.list.length);
    screen = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => service<HomeNotifier>()),
        ChangeNotifierProvider(create: (_) => service<HeadlineNotifier>()),
      ],
      child: Scaffold(
        body: NestedScrollView(headerSliverBuilder: (context, scrolled) {
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
                            'nCOVID-19 Stats',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        )
                        /**/,
                      ),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: AnimatedBuilder(
                            animation: _animationRefresh,
                            child: Image.asset(
                              'asset/refresh.png',
                              height: 25,
                              width: 25,
                              filterQuality: FilterQuality.high,
                            ),
                            builder: (context, child) {
                              return Transform.rotate(
                                  angle: _animationRefresh.value * pi * 2 * 18,
                                  child: GestureDetector(
                                    child: child,
                                    onTap: () {
                                      _notesNotifier.getAll('all');
                                      _animationControllerRefresh.reset();
                                      _animationControllerRefresh.repeat();
                                      _started = true;
                                    },
                                  ));
                            },
                          )),
                      Positioned(
                        top: 35,
                        right: 5,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade400.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text('About',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutMe()));
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.all(5),
                          width: screen.width * 0.65,
                          child: InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(Data.list[no],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
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
              if (_started) {
                _started = false;
                _animationControllerRefresh.stop();
              }
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    getListItem(
                        'Total Cases',
                        model.notes.cases,
                        'asset/patient.png',
                        Colors.lightBlueAccent.shade400,
                        model),
                    getListItem(
                        'Recovered',
                        model.notes.recovered,
                        'asset/wheelchair.png',
                        Colors.lightGreenAccent.shade700,
                        model),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    getListItem('Total Deaths', model.notes.deaths,
                        'asset/skull.png', Colors.red.shade500, model),
                    getListItem('Active', model.notes.active,
                        'asset/active.png', Colors.orangeAccent.shade700, model)
                  ],
                ),
                FittedBox(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TopCountry()));
                          },
                          child: Card(
                            color: Colors.indigo.shade500,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              height: screen.height * 0.06,
                              width: screen.width * 0.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                    'asset/global.png',
                                    color: Colors.white,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Text(
                                    'Affected\nCountries',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StatesInfo()));
                          },
                          child: Card(
                            color: Colors.indigo.shade500,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              height: screen.height * 0.06,
                              width: screen.width * 0.3,
                              child: Text(
                                'Indian \nStates Tally',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 8, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CovidMap()));
                          },
                          child: Card(
                            color: Colors.indigo.shade500,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              height: screen.height * 0.06,
                              width: screen.width * 0.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                    'asset/india.png',
                                    color: Colors.white,
                                    height: 20,
                                    width: 20,
                                  ),
                                  Text(
                                    'COVID \nMap',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: Card(
                    color: Colors.indigo.shade500,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      alignment: Alignment.center,
                      height: screen.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Top headlines',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                          Container(
                            height: 25,
                            width: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://raw.githubusercontent.com/NovelCOVID/API/master/assets/flags/in.png"))),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer<HeadlineNotifier>(
                  builder: (context, headlineModel, child) {
                    _headlineNotifier = headlineModel;
                    if (headlineModel.state == NoteStates.Busy) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ),
                        ),
                      );
                    } else {
                      if (headlineModel.file != null && _dialog) {
                        Future.delayed(Duration(milliseconds: 300))
                            .then((onValue) {
                          _dialog = false;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return showCustomDialog(
                                    context, headlineModel.file);
                              });
                        });
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0),
                          child: ListView.separated(
                            padding: MediaQuery.of(context)
                                .removePadding(removeTop: true)
                                .padding,
                            // ignore: missing_return
                            separatorBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 1,
                                alignment: Alignment.center,
                                color: Colors.black26,
                              );
                            },
                            itemCount: headlineModel.headlines.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {
                                  final url = headlineModel.headlines[i].url;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        headlineModel.headlines[i].title,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            );
          },
        )),
      ),
    );
  }

  Widget getListItem(
      String title, final item, String image, Color color, HomeNotifier model) {
    return Card(
      color: color,
      child: Container(
        padding: EdgeInsets.all(8),
        width: screen.width * 0.45,
        height: screen.height * 0.14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              image,
              height: 30,
              fit: BoxFit.fill,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 17),
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
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget showCustomDialog(BuildContext context, Uint8List image) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 30,
      child: Container(
        height: screen.width * 0.8,
        width: screen.width * 0.8,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            image:
                DecorationImage(image: MemoryImage(image), fit: BoxFit.fill)),
      ),
    );
  }
}
