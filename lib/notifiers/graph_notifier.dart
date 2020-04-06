import 'package:COVID19/models/graph_model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:COVID19/data.dart';
import 'package:COVID19/api/middleware.dart';
import 'package:COVID19/api/service.dart';
import 'package:flutter/cupertino.dart';

class GraphNotifier extends ChangeNotifier{

  List<GraphCaseModel> _cases =[];
  List<GraphCaseModel> get notes => _cases;

  MiddleWare api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;
  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();


  getGraphData(String country) async {
    setState(NoteStates.Busy);
    http.Response userProfile = await api.getGraphData(country);
    Iterable iterable = jsonDecode(userProfile.body)['response'];
    debugPrint(userProfile.body);
    _cases = iterable.map((e) => GraphCaseModel.fromJson(e)).toList();
    setState(NoteStates.Done);
  }

}