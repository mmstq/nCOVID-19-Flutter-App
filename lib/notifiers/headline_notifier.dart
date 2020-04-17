import 'dart:convert';
import 'dart:typed_data';
import 'package:COVID19/api/api_urls.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/headline_model.dart';
import 'package:COVID19/api/service.dart';
import 'package:http/http.dart' as http;
import 'package:COVID19/api/middleware.dart';
import 'package:flutter/cupertino.dart';

class HeadlineNotifier extends ChangeNotifier{

  List<HeadLine> _headlines;
  Uint8List file;

  List<HeadLine> get headlines => _headlines;

  MiddleWare _api = service<MiddleWare>();

  final _intSize = 286608;

  NoteStates _state = NoteStates.Busy;

  NoteStates get state => _state;

  void _setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void getHeadlines() async {
    _setState(NoteStates.Busy);
    http.Response _userProfile = await _api.getHeadlines();
    Iterable _iterable = jsonDecode(_userProfile.body)['articles'];
    _headlines = _iterable.map((e) => HeadLine.fromJson(e)).toList();
    _setState(NoteStates.Done);
    /*_api.getRandomMaskUsageImage().then((object){
      if(object.bodyBytes.toList().length != _intSize)
        file = object.bodyBytes;
        notifyListeners();
    });*/

  }

}
