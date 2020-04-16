import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/pages/single_country_stats.dart';
import 'package:flutter/material.dart';

class SearchByCountry extends SearchDelegate {
  final List<CaseModel> _cases;

  SearchByCountry(this._cases);

  var style = TextStyle(
      fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.w300);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<CaseModel> result =[];
    if (query.length > 0) {
      result= _cases.where((element) => element.country.toLowerCase().contains(query)).toList();
    }

    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: ListView(
        children: result.map((e){
          return InkWell(
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CountryStats(e)));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
              child: Row(
                children: <Widget>[
                  Image.network(
                    e.countryInfo.flag,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    e.country,
                    style: style.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
