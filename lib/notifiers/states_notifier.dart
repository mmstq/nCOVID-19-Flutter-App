
import 'package:covid19/models/state_model.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:covid19/data.dart';
import 'package:covid19/api/middleware.dart';
import 'package:covid19/api/service.dart';
import 'package:flutter/cupertino.dart';

class StatesNotifier extends ChangeNotifier{
  static final list = ['Maharashtra','Tamil Nadu',"Delhi","Telangana","Rajasthan","Uttar Pradesh","Madhya Pradesh","Andhra Pradesh","Kerala","Gujarat","Karnataka","Jammu and Kashmir","Haryana","Punjab","West Bengal","Bihar","Odisha","Uttarakhand","Assam","Himachal Pradesh","Chandigarh","Chhattisgarh","Ladakh","Jharkhand","Andaman and Nicobar Islands","Goa","Puducherry","Manipur","Tripura","Mizoram", "Dadra and Nagar Haveli","Arunachal Pradesh","Daman and Diu","Lakshadweep","Meghalaya","Nagaland","Sikkim"];

  bool isNull = false;

  List<StateModel> _cases=[];
  List<StateModel> get notes => _cases;

  MiddleWare api = service<MiddleWare>();

  NoteStates _state = NoteStates.Busy;
  NoteStates get state => _state;

  void setState(NoteStates state) {
    _state = state;
    notifyListeners();
  }

  void notify() => notifyListeners();

  getAll() async {
    setState(NoteStates.Busy);
    http.Response userProfile = await api.getStatesData();
    Map<String, dynamic> iterable = jsonDecode(userProfile.body)['state_wise'];
    iterable.forEach((key, value){
      _cases.add(StateModel.fromJson(value));
    });
    setState(NoteStates.Done);
  }

}