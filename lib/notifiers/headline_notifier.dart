import 'dart:convert';
import 'dart:typed_data';
import 'package:covid19/data.dart';
import 'package:covid19/models/headline_model.dart';
import 'package:covid19/api/service.dart';
import 'package:http/http.dart' as http;
import 'package:covid19/api/middleware.dart';
import 'package:flutter/cupertino.dart';

class HeadlineNotifier extends ChangeNotifier{

  List<HeadLine> _headlines;
  Uint8List file;

  List<HeadLine> get headlines => _headlines;

  MiddleWare _api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;

  NoteStates get state => _state;

  void _setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void getHeadlines() async {
    _setState(NoteStates.Busy);
    http.Response _userProfile = await _api.getHeadlines();
    debugPrint(_userProfile.body);
    Iterable _iterable = jsonDecode(_userProfile.body)['articles'];
    _headlines = _iterable.map((e) => HeadLine.fromJson(e)).toList();
    _setState(NoteStates.Done);

  }

}
