import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/notifiers/country_notifier.dart';
import 'package:COVID19/pages/searchByCountry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

class TopCountry extends StatefulWidget {
  @override
  _TopCountryState createState() => _TopCountryState();
}

class _TopCountryState extends State<TopCountry> {
  CountryNotifier _model;
  CaseModel india;
  List<CaseModel> _list=[];
  String _sortString = 'cases';
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _model.getAll(_sortString);
    });
  }

  final listSort = ['Cases','Deaths', 'Recovered','Country'];

  final FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);

  var style = TextStyle(
      fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w300);

  PopupMenuButton<String> _simplePopup() => PopupMenuButton<String>(
    icon: Icon(Icons.sort),
    padding: EdgeInsets.all(0),
    itemBuilder: (context) {
      var list =listSort.map((e) {
        return (PopupMenuItem(
          value: e.toLowerCase(),
          child: Text(e, style: (e.toLowerCase() == _sortString)?TextStyle(
            fontWeight: FontWeight.w700,
            color:  Theme.of(context).primaryColor
          ):TextStyle(color: Colors.grey.shade700)),
        ));
      }).toList();

      return list;

    },
    onSelected: (value){
      _sortString = value;
      _model.sort(_sortString);
    },
  );

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => service<CountryNotifier>(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("nCOVID-19"),
          actions: <Widget>[
            Consumer<CountryNotifier>(
              builder: (context1, model1, child1){
                return IconButton(
                  splashColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.search),
                    onPressed:(model1.state == NoteStates.Done)? () {
                      showSearch(
                          context: context, delegate: SearchByCountry(_model.notes));
                    }:null
                );
              },
            ),
            _simplePopup()
          ],
        ),
        body: Consumer<CountryNotifier>(
          builder: (context, model, child) {

            _model = model;
            if (model.state == NoteStates.Busy) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Loading, Wait...')
                    ],
                  ),
                ),
              );
            } else
              _list = model.notes;
              india = _list
                  .firstWhere((element) => element.country == 'India');
            /*if(_sortString == 'country')
              _list = model.notes.reversed.toList();
            else*/
            return ListView.builder(
              /*separatorBuilder: (c, i) => Container(
                height: 0.5,
                color: Colors.grey,
              ),*/
              itemCount: _list.length,

              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: <Widget>[
                      getListItem(context, india, screen, true),
                      Container(height: 2,width: screen.width,color: Colors.grey.withOpacity(0.3),),
                      getListItem(context, _list[index], screen, false)
                    ],
                  );
                }else
                  return getListItem(context, _list[index], screen, false);
              },
            );
          },
        ),
      ),
    );
  }

  Widget getListItem(BuildContext context, CaseModel caseModel, Size screen, bool expanded) {

    return ExpansionTile(
      initiallyExpanded: expanded,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: <Widget>[
            Image.network(
              caseModel.countryInfo.flag,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              caseModel.country,
              style: style.copyWith(fontWeight: FontWeight.w600,fontSize: 17, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Cases',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${_fmf.copyWith(amount: caseModel.cases.floorToDouble()).output.withoutFractionDigits}',
                  style: TextStyle(
                      color: Colors.black87)
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Deaths',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '${_fmf.copyWith(amount: caseModel.deaths.floorToDouble()).output.withoutFractionDigits}',
                    style: TextStyle(
                    color: Colors.black87)),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Recovered',
                  style: TextStyle(
                      color: Colors.lightGreenAccent.shade700,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '${_fmf.copyWith(amount: caseModel.recovered.floorToDouble()).output.withoutFractionDigits}',
                    style: TextStyle(
                        color: Colors.black87)),
              ],
            ),

          ],
        ),
      ),
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
          height: 0.5,
          width: screen.width * 0.9,
          color: Colors.grey.shade500,
        ),
/*        Text(
          "More Stats",
          style: style.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
        )*/
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 35, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Cases\nToday',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${_fmf.copyWith(amount: caseModel.todayCases.floorToDouble()).output.withoutFractionDigits}',
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Deaths\nToday',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${_fmf.copyWith(amount: caseModel.todayDeaths.floorToDouble()).output.withoutFractionDigits}'),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Total\nCritical',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${_fmf.copyWith(amount: caseModel.critical.floorToDouble()).output.withoutFractionDigits}'),
                ],
              )

            ],
          ),
        )
      ],
    );
  }
}
