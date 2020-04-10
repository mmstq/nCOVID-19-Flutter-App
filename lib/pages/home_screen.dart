import 'dart:math';
import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/pages/india_map.dart';
import 'package:COVID19/pages/states_wise_stats.dart';
import 'package:COVID19/notifiers/headline_notifier.dart';
import 'package:COVID19/notifiers/homescreen_notifier.dart';
import 'package:COVID19/pages/about_me.dart';
import 'package:COVID19/pages/all_country_info.dart';
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
  AnimationController _animationController;
  CurvedAnimation _animation;
  Animation<double> _tween;
  AnimationController _animationControllerRefresh;
  CurvedAnimation _animationRefresh;
  Animation<double> _tweenRefresh;
  bool _started = true;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _tween = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation = CurvedAnimation(parent: _tween, curve: Curves.ease);
    _animation.addListener(() {
      _notesNotifier.notify();
    });

    _animationControllerRefresh = AnimationController(
        duration: Duration(seconds: 20), vsync: this);
    _tweenRefresh =
        Tween<double>(begin: 0, end: 1).animate(_animationControllerRefresh);
    _animationRefresh =
        CurvedAnimation(parent: _tweenRefresh, curve: Curves.linear);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _notesNotifier.getAll('all').then((value) {
        _headlineNotifier.getHeadlines();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _animationControllerRefresh.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final no = Random().nextInt(Data.list.length);
    final screen = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => service<HomeNotifier>()),
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
                        child:
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.all(5),
                          child: Text('nCOVID-19 Stats', style: TextStyle(fontSize: 17, color: Colors.white),),
                        )
                        /**/,
                      ),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: AnimatedBuilder(
                            animation: _animationRefresh,
                            child: Image.asset('asset/refresh.png', height: 25,width: 25,filterQuality: FilterQuality.high,),
                            builder: (context, child) {
                              return Transform.rotate(
                                  angle: _animationRefresh.value * pi * 2*18,
                                  child: GestureDetector(
                                    child: child,
                                    onTap: () {
                                      _notesNotifier.getAll('all');
                                      _animationController.reset();
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
                                Icon(Icons.person, color: Colors.white,),
                                Text('About',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutMe()));
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
            if (model.state == NoteStates.Busy) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            } else {
              if (_started) {
                _started = false;
                _animationController.forward();
                _animationControllerRefresh.stop();
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
                      Card(
                        color: Colors.lightBlueAccent.shade400,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: screen.width * 0.45,
                          height: screen.height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                'asset/patient.png',
                                height: 40,
                              ),
                              Text(
                                'Total Cases',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                  '${_fmf.copyWith(amount: _animation.value * model.notes.cases).output.withoutFractionDigits}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.lightGreenAccent.shade700,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: screen.width * 0.45,
                          height: screen.height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                'asset/wheelchair.png',
                                height: 40,
                              ),
                              Text(
                                'Recovered',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                  '${_fmf.copyWith(amount: _animation.value * model.notes.recovered).output.withoutFractionDigits}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Card(
                        color: Colors.red.shade500,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: screen.width * 0.45,
                          height: screen.height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                'asset/skull.png',
                                height: 38,
                              ),
                              Text(
                                'Total Deaths',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                  '${_fmf.copyWith(amount: _animation.value * model.notes.deaths).output.withoutFractionDigits}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.orangeAccent.shade700,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: screen.width * 0.45,
                          height: screen.height * 0.16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Image.asset(
                                'asset/active.png',
                                height: 40,
                              ),
                              Text(
                                'Active',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                  '${_fmf.copyWith(amount: _animation.value * model.notes.active).output.withoutFractionDigits}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  FittedBox(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
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
                                width: screen.width*0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset('asset/global.png', color: Colors.white,height: 20,width: 20,),
                                    Text(
                                      'Affected\ncountries',
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
                                width: screen.width*0.3,

                                child: Text(
                                  'Indian \nstates tally',
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
                          padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
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
                                width: screen.width*0.3,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset('asset/india.png', color: Colors.white, height: 20,width: 20,),
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
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Card(
                      color: Colors.indigo.shade500,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        alignment: Alignment.center,
                        height: screen.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Top headlines',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
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
                    builder: (context, hlmodel, child) {
                      _headlineNotifier = hlmodel;
                      if (hlmodel.state == NoteStates.Busy) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                              itemCount: hlmodel.headlines.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () async {
                                    final url = hlmodel.headlines[i].url;
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
                                      child: Text(hlmodel.headlines[i].title,
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
            }
          },
        )),
      ),
    );
  }
}
