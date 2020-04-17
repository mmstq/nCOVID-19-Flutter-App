
import 'dart:convert';
import 'package:COVID19/api/api_urls.dart';
import 'package:COVID19/models/case_model.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/api/service.dart';
import 'package:COVID19/models/image_model.dart';
import 'package:http/http.dart' as http;
import 'package:COVID19/api/middleware.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';


class HomeNotifier extends ChangeNotifier{

  CaseModel _cases = CaseModel(cases: 0, recovered: 0, active: 0, deaths: 0);

  CaseModel get notes => _cases;

  List<ImageModel> _images = [];

  List<ImageModel> get images => _images;
  MiddleWare _api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;

  bool updateAvailable = false;

  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();


  getAll(String path) async {
    getUpdate();
    getWhoImages();
    setState(NoteStates.Busy);
    http.Response _userProfile = await _api.get(path);
    var _iterable = jsonDecode(_userProfile.body);
    _cases = CaseModel.fromJson(_iterable);
    setState(NoteStates.Done);
  }

  getUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    http.Response _userProfile = await _api.getUpdate();
    final map = json.decode(_userProfile.body);
    ApiURL.apkURL = map['apkURL'];
    if(map['version'] != version){
      updateAvailable = true;
      notify();
    }
  }
  getWhoImages() async {
    http.Response _userProfile = await _api.getRandomMaskUsageImage();
    final map = json.decode(_userProfile.body);
    map.forEach((value){
      _images.add(ImageModel.fromJson(value));
    });
    notify();


  }



}