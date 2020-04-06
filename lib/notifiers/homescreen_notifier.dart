
import 'dart:convert';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/api/service.dart';
import 'package:http/http.dart' as http;
import 'package:COVID19/api/middleware.dart';
import 'package:flutter/cupertino.dart';

class HomeNotifier extends ChangeNotifier{

  CaseModel _cases;

  CaseModel get notes => _cases;

  MiddleWare api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;

  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();


  Future<dynamic> getAll(String path) async {
    setState(NoteStates.Busy);
    http.Response userProfile = await api.get(path);
    var iterable = jsonDecode(userProfile.body);
    _cases = CaseModel.fromJson(iterable);
    setState(NoteStates.Done);
    return userProfile;
  }

}