import 'dart:convert';
import 'package:COVID19/data.dart';
import 'package:COVID19/models/headline_model.dart';
import 'package:COVID19/api/service.dart';
import 'package:http/http.dart' as http;
import 'package:COVID19/api/middleware.dart';
import 'package:flutter/cupertino.dart';

class HeadlineNotifier extends ChangeNotifier{

  List<HeadLine> _headlines;

  List<HeadLine> get headlines => _headlines;

  MiddleWare _api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;

  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();

  Future<dynamic> getHeadlines() async {
    var path = 'https://newsapi.org/v2/top-headlines?q=COVID&from=2020-03-16&sortBy=publishedAt&apiKey=65a8e68e1ddb4adb816120b8c2cd354e&pageSize=10&page=1&country=in';
    setState(NoteStates.Busy);
    http.Response userProfile = await _api.getHeadlines(path);
    Iterable iterable = jsonDecode(userProfile.body)['articles'];
    _headlines = iterable.map((e) => HeadLine.fromJson(e)).toList();
    setState(NoteStates.Done);
    return userProfile;
  }

}