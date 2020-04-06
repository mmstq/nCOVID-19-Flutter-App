import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/models/graph_model.dart';
import 'package:COVID19/notifiers/graph_notifier.dart';
import 'package:bezier_chart/bezier_chart.dart';
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
  AnimationController _animationController;
  GraphNotifier _graphNotifier;
  CurvedAnimation _animation;
  Animation<double> _tween;
  FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);

  var style = TextStyle(
      fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w300);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _tween = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animation = CurvedAnimation(parent: _tween, curve: Curves.decelerate);
    _animation.addListener(() {
      setState(() {});
    });
    _animationController.forward();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _graphNotifier.getGraphData(widget._model.country.toLowerCase());
    });
  }


  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider<GraphNotifier>(
      create: (context) => service<GraphNotifier>(),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget._model.country),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Card(
                elevation: 1,
                margin: EdgeInsets.all(14),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                child: Image.network(
                  widget._model.countryInfo.flag,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Consumer<GraphNotifier>(
              builder: (context, model, child) {
                _graphNotifier = model;
                if (model.state == NoteStates.Done) {
                  List<GraphCaseModel> list = [];
                  var date = '';
                  model.notes.forEach((e){
                    if(e.day != date) {
                      date = e.day;
                      list.add(e);
                      return true;
                    }else{
                      return false;
                    }
                  });
                  list = list.reversed.toList();
                  list.forEach((element) {
                    debugPrint(element.day);
                  });

                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: BezierChart(
                      fromDate: DateTime.parse(list[0].day),
                      toDate: DateTime.parse(list[list.length-1].day),
                      bezierChartScale: BezierChartScale.WEEKLY,
                      selectedDate: DateTime.parse(list[list.length-1].day),
                      series: [
                        BezierLine(
                            lineColor: Colors.redAccent,
                            label: "Cases",
                            data: list.map((e) {
                              return DataPoint<DateTime>(
                                  value: e.cases.total.ceilToDouble(),
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
                        xLinesColor: Colors.indigoAccent.withOpacity(0.4),
                        displayDataPointWhenNoValue: true,
                        backgroundColor: Colors.indigo,
                        footerHeight: 50.0,
                      ),
                    ),
                  );

                } else
                  return Container();
              },
            ),
            SizedBox(height: 10,),
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.cases).output.withoutFractionDigits}',
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.recovered).output.withoutFractionDigits}',
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.deaths).output.withoutFractionDigits}',
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.active).output.withoutFractionDigits}',
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
                  color: Colors.indigo.shade500,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: screen.width * 0.45,
                    height: screen.height * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          'asset/skull.png',
                          height: 40,
                        ),
                        Text(
                          'Today Deaths',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.todayDeaths).output.withoutFractionDigits}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Colors.purple.shade400,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: screen.width * 0.45,
                    height: screen.height * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          'asset/patient.png',
                          height: 38,
                        ),
                        Text(
                          'Today Cases',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.todayCases).output.withoutFractionDigits}',
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
            /*SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  color: Colors.amberAccent.shade700,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: screen.width * 0.45,
                    height: screen.height * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image.asset(
                          'asset/alert.png',
                          height: 38,
                        ),
                        Text(
                          'Critical',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                            '${_fmf.copyWith(amount: _animation.value * widget._model.critical).output.withoutFractionDigits}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
