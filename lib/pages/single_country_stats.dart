import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/models/graph_model.dart';
import 'package:COVID19/notifiers/graph_notifier.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

class CountryStats extends StatefulWidget {
  final CaseModel _model;

  CountryStats(this._model);

  @override
  _CountryStatsState createState() => _CountryStatsState();
}

class _CountryStatsState extends State<CountryStats>
    with SingleTickerProviderStateMixin {
  GraphNotifier _graphNotifier;
  Size _screen;
  FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _graphNotifier.getGraphData(widget._model.country.toLowerCase());
    });
  }


  @override
  Widget build(BuildContext context) {
    _screen = MediaQuery
        .of(context)
        .size;
    return ChangeNotifierProvider<GraphNotifier>(
      create: (context) => service<GraphNotifier>(),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget._model.country),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CachedNetworkImage(
                imageUrl:
                'https://www.countryflags.io/${widget._model.countryInfo
                    .iso2}/flat/64.png',
                height: 35,
                width: 35,
                placeholder: (_, url) =>
                    Image.asset('asset/unknown.png', height: 35, width: 35,),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getListItem(
                    'Total Cases',
                    widget._model.cases,
                    'asset/patient.png',
                    Colors.lightBlueAccent.shade400),
                getListItem(
                    'Recovered',
                    widget._model.recovered,
                    'asset/wheelchair.png',
                    Colors.lightGreenAccent.shade700),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getListItem('Total Deaths', widget._model.deaths,
                    'asset/skull.png', Colors.red.shade500),
                getListItem('Active', widget._model.active,
                    'asset/active.png', Colors.orangeAccent.shade700)

              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                getListItem('Today Deaths', widget._model.todayDeaths,
                    'asset/skull.png', Colors.indigo.shade500),
                getListItem('Today Cases', widget._model.todayCases,
                    'asset/patient.png', Colors.purple.shade400)
              ],
            ),
            Consumer<GraphNotifier>(
              builder: (context, model, child) {
                _graphNotifier = model;
                if (model.state == NoteStates.Done) {
                  if (model.notes.isNotEmpty) {
                    return FutureBuilder<List<GraphCaseModel>>(
                      future: getList(model),
                      builder: (BuildContext context, AsyncSnapshot<List<
                          GraphCaseModel>> snap) {

                        if (snap.hasData) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: _screen.height / 3,
                            width: _screen.width,
                            child: BezierChart(
                              fromDate: DateTime.parse(snap.data[0].day),
                              toDate: DateTime.parse(
                                  snap.data[snap.data.length - 1].day),
                              bezierChartScale: BezierChartScale.WEEKLY,
                              selectedDate: DateTime.parse(
                                  snap.data[snap.data.length - 1].day),
                              series: [
                                BezierLine(
                                    lineColor: Colors.blueAccent,
                                    label: "Cases",
                                    data: snap.data.map((e) {
                                      return DataPoint<DateTime>(
                                          value: e.cases.total.ceilToDouble(),
                                          xAxis: DateTime.parse(e.day));
                                    }).toList()),
                                BezierLine(
                                    lineColor: Colors.redAccent,
                                    label: "Deaths",
                                    data: snap.data.map((e) {
                                      return DataPoint<DateTime>(
                                          value: e.deaths.total.ceilToDouble(),
                                          xAxis: DateTime.parse(e.day));
                                    }).toList()),
                                BezierLine(
                                    lineColor: Colors.orange,
                                    label: "Active",
                                    data: snap.data.map((e) {
                                      return DataPoint<DateTime>(
                                          value: e.cases.active.ceilToDouble(),
                                          xAxis: DateTime.parse(e.day));
                                    }).toList()),
                                BezierLine(
                                    lineColor: Colors.lightGreenAccent.shade700,
                                    label: "Recovered",
                                    data: snap.data.map((e) {
                                      return DataPoint<DateTime>(
                                          value: e.cases.recovered
                                              .ceilToDouble(),
                                          xAxis: DateTime.parse(e.day));
                                    }).toList()),
                              ],
                              config: BezierChartConfig(
                                verticalIndicatorStrokeWidth: .5,
                                verticalIndicatorColor: Colors.transparent,
                                showVerticalIndicator: false,
                                showDataPoints: true,
                                displayLinesXAxis: true,
                                pinchZoom: true,
                                xLinesColor: Colors.indigoAccent.withOpacity(
                                    0.4),
                                displayDataPointWhenNoValue: true,
                                backgroundColor: Colors.indigo,
                                footerHeight: 50.0,
                              ),
                            ),
                          );
                        }
                        return getLoadingBar();
                      },
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      height: _screen.height / 3,
                      width: _screen.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error, color: Theme
                              .of(context)
                              .accentColor, size: 40,),
                          SizedBox(height: 10,),
                          Text('Graph Data Not\nAvailable', textAlign: TextAlign
                              .center, style: TextStyle(color: Theme
                              .of(context)
                              .accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),),
                        ],
                      ),
                    );
                  }
                } else
                  return getLoadingBar();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget getLoadingBar(){
    return Container(
      key: Key('container'),
      padding: EdgeInsets.all(_screen.height / 7),
      height: _screen.height / 3,
      width: _screen.height / 3,
      child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(strokeWidth: 1.5,)),
    );

  }

  Future<List<GraphCaseModel>> getList(final model)async {
    await Future.delayed(Duration(seconds: 1));
    List<GraphCaseModel> list = [];
    var _date = '';
    await model.notes.forEach((e) {
      if (e.day != _date) {
        _date = e.day;
        list.add(e);
        return true;
      } else {
        return false;
      }
    });
    return list.reversed.toList();
  }


        Widget getListItem(
        String title, final item, String image, Color color)
    {
      return Card(
        color: color,
        child: Container(
          padding: EdgeInsets.all(8),
          width: _screen.width * 0.45,
          height: _screen.height * 0.14,
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
              getTotalCount(item)
            ],
          ),
        ),
      );
    }

    Widget getTotalCount(final item) {
      final style = TextStyle(
          shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w700);
      return TweenAnimationBuilder(
        curve: Curves.decelerate,
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(seconds: 1),
        builder: (_, value, child) {
          final string = '${_fmf
              .copyWith(amount: value * item)
              .output
              .withoutFractionDigits}';
            return Text(string,
                style: style);}
      );
    }
  }
