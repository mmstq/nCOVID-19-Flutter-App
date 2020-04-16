import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/district_model.dart';
import 'package:COVID19/models/state_model.dart';
import 'package:COVID19/notifiers/states_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

class StatesInfo extends StatefulWidget {
  @override
  _StatesInfoState createState() => _StatesInfoState();
}

class _StatesInfoState extends State<StatesInfo> {
  StatesNotifier _model;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _model.getAll();
    });
  }

  final FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);

  final _style = TextStyle(
      fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w300);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => service<StatesNotifier>(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Indian States Tally"),
        ),
        body: Consumer<StatesNotifier>(
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
              return ListView.separated(
                separatorBuilder: (context, i) => Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                itemCount: model.notes.length,
                itemBuilder: (context, index) {
                  return getListItem(context, model.notes[index], screen);
                },
              );
          },
        ),
      ),
    );
  }

  Widget getListItem(BuildContext context, StateModel caseModel, Size screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DistrictsInfo(caseModel.districts, caseModel.state),
          ),
        );
      },
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                caseModel.state,
                style: _style.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.grey.shade800),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 15),
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
                      '${_fmf.copyWith(amount: double.parse(caseModel.confirmed)).output.withoutFractionDigits}',
                      style: TextStyle(color: Colors.black87)),
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
                      '${_fmf.copyWith(amount: double.parse(caseModel.deaths)).output.withoutFractionDigits}',
                      style: TextStyle(color: Colors.black87)),
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
                      '${_fmf.copyWith(amount: double.parse(caseModel.recovered)).output.withoutFractionDigits}',
                      style: TextStyle(color: Colors.black87)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Active',
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${_fmf.copyWith(amount: double.parse(caseModel.active)).output.withoutFractionDigits}',
                      style: TextStyle(color: Colors.black87)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DistrictsInfo extends StatefulWidget {
  final Map _map;
  final String _title;

  DistrictsInfo(this._map, this._title);

  @override
  _DistrictsInfoState createState() => _DistrictsInfoState();
}

class _DistrictsInfoState extends State<DistrictsInfo> {
  List<DistrictModel> _districts = [];

  @override
  void initState() {
    super.initState();
    if (widget._map != null)
      widget._map
          .forEach((key, value) => _districts.add(DistrictModel(key, value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: (_districts.isEmpty)
          ? Center(
              child: Text('No district affected'),
            )
          : ListView.separated(
              separatorBuilder: (context, i) => Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              itemCount: _districts.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((_districts[index].district == 'Unknown')
                      ? 'Unknown regions'
                      : _districts[index].district),
                  subtitle: Text(
                      'Confirmed cases: ${_districts[index].cases['confirmed']}'),
                );
              },
            ),
    );
  }
}
