import 'package:covid19/api/middleware.dart';
import 'package:covid19/api/service.dart';
import 'package:covid19/data.dart';
import 'package:covid19/models/case_model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class CountryNotifier extends ChangeNotifier{

  List<CaseModel> _cases;
  List<CaseModel> get notes => _cases;

  MiddleWare api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;
  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();


  getAll(String path) async {
    setState(NoteStates.Busy);
    http.Response userProfile = await api.get('countries?sort=$path');
    Iterable iterable = jsonDecode(userProfile.body);
    _cases = iterable.map((e) => CaseModel.fromJson(e)).toList();
    setState(NoteStates.Done);
  }
  sort(String comparator) async {
    setState(NoteStates.Busy);
    switch(comparator){
      case 'country':
        _cases.sort((a,b)=>a.country.compareTo(b.country));
        break;
      case 'deaths':
        _cases.sort((a,b)=>b.deaths.compareTo(a.deaths));
        break;
      case 'cases':
        _cases.sort((a,b)=>b.cases.compareTo(a.cases));
        break;
      case 'recovered':
        _cases.sort((a,b)=>b.recovered.compareTo(a.recovered));
        break;

    }

    setState(NoteStates.Done);
  }

}