import 'package:covid19/api/covid_api.dart';
import 'package:covid19/api/service.dart';
import 'package:http/http.dart' as http;

class MiddleWare {

  NoteAPI _api = service<NoteAPI>();
  Future<dynamic> get(String queryCountry) async {
    http.Response userProfile = await _api.get(queryCountry);
    return userProfile;
  }
  Future<dynamic> getUpdate() async {
    http.Response userProfile = await _api.checkForUpdate();
    return userProfile;
  }
  Future<dynamic> getHeadlines() async {
    http.Response userProfile = await _api.getHeadlines();
    return userProfile;
  }

  Future<dynamic> getGraphData(String country) async {
    http.Response userProfile = await _api.getGraphData(country);
    return userProfile;
  }

  Future<dynamic> getStatesData() async {
    http.Response userProfile = await _api.getStatesData();
    return userProfile;
  }
  Future<dynamic> getRandomMaskUsageImage() async {
    http.Response userProfile = await _api.getRandomMaskUsageImage();
    return userProfile;
  }
}