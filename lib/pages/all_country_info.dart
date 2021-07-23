import 'package:covid19/api/service.dart';
import 'package:covid19/data.dart';
import 'package:covid19/models/case_model.dart';
import 'package:covid19/notifiers/country_notifier.dart';
import 'package:covid19/pages/search_country.dart';
import 'package:covid19/pages/single_country_stats.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  List<CaseModel> _list = [];
  String _sortString = 'cases';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _model.getAll(_sortString);
    });
  }


  final listSort = ['Cases', 'Deaths', 'Recovered', 'Country'];

  final FlutterMoneyFormatter _fmf = FlutterMoneyFormatter(amount: 620000);

  var style = TextStyle(
      fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w300);

  PopupMenuButton<String> _simplePopup() => PopupMenuButton<String>(
        icon: Icon(Icons.sort),
        padding: EdgeInsets.all(0),
        itemBuilder: (context) {
          var list = listSort.map((e) {
            return (PopupMenuItem(
              value: e.toLowerCase(),
              child: Text(e,
                  style: (e.toLowerCase() == _sortString)
                      ? TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor)
                      : TextStyle(color: Colors.grey.shade700)),
            ));
          }).toList();

          return list;
        },
        onSelected: (value) {
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
              builder: (context1, model1, child1) {
                return IconButton(
                    splashColor: Theme.of(context).primaryColor,
                    icon: Icon(Icons.search),
                    onPressed: (model1.state == NoteStates.Done)
                        ? () {
                            showSearch(
                                context: context,
                                delegate: SearchByCountry(_model.notes));
                          }
                        : null);
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
            return ListView.builder(
//              physics: BouncingScrollPhysics(),
              cacheExtent: 10,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return getListItem(context, _list[index], screen);
              },
            );
          },
        ),
      ),
    );
  }

  Widget getListItem(BuildContext context, CaseModel caseModel, Size screen) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl:
                  'https://www.countryflags.io/${caseModel.countryInfo.iso2}/flat/64.png',
              height: 25,
              width: 25,
              placeholder: (_,url)=>Image.asset('asset/unknown.png', height: 25,width: 25,),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                caseModel.country,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.grey.shade800),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            getCurveWidget(caseModel)
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
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Deaths',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '${_fmf.copyWith(amount: caseModel.deaths.floorToDouble()).output.withoutFractionDigits}',
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
                    '${_fmf.copyWith(amount: caseModel.recovered.floorToDouble()).output.withoutFractionDigits}',
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCurveWidget(CaseModel caseModel) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CountryStats(caseModel)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'curve ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            Icon(
              Icons.show_chart,
              size: 14,
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}
