
import 'dart:convert';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/api/service.dart';
import 'package:http/http.dart' as http;
import 'package:COVID19/api/middleware.dart';
import 'package:flutter/cupertino.dart';

class HomeNotifier extends ChangeNotifier{

  CaseModel _cases = CaseModel(cases: 0, recovered: 0, active: 0, deaths: 0);

  CaseModel get notes => _cases;

  MiddleWare _api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;

  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();


  getAll(String path) async {
    setState(NoteStates.Busy);
    http.Response _userProfile = await _api.get(path);
    var _iterable = jsonDecode(_userProfile.body);
    _cases = CaseModel.fromJson(_iterable);
    setState(NoteStates.Done);
  }

}