import 'dart:io';
import 'package:COVID19/api/api_urls.dart';
import 'package:COVID19/api/error_handling.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NoteAPI {
  final _baseURL = ApiURL.baseURL;
  final _host = ApiURL.host;
  final _url = ApiURL.url;
  final _stateURL = ApiURL.stateURL;
  final _hostStateData = ApiURL.hostStateData;
  final _key = ApiURL.key;
  final _internalHostName = ApiURL.rapidHost;
  final _internalHostKey = ApiURL.rapidKey;

  Future<dynamic> get(String apiPath) async {
    http.Response _response;
    try {
      _response = await http.get(_baseURL + apiPath);
      _response = _responseCheck(_response);
    } on SocketException {
      throw TooManyRequests("Not connected to internet");
    }
    return _response;
  }

  Future<dynamic> getHeadlines(String apiPath) async {
    http.Response _response;
    try {
      _response = await http.get(apiPath);
      _response = _responseCheck(_response);
    } on SocketException {
      throw TooManyRequests("Not connected to internet");
    }
    return _response;
  }

  Future<dynamic> getGraphData(String country) async {
    
    http.Response _response;
    debugPrint('country is $country');
    try {
      _response = await http.get(_url + '?country=$country',
          headers: {_internalHostName: _host, _internalHostKey: _key});
      _response = _responseCheck(_response);
    } on SocketException {
      throw TooManyRequests("Not connected to internet");
    }
    return _response;
  }

  Future<dynamic> getStatesData() async {

    http.Response _response;
    try {
      _response = await http.get(_stateURL,
          headers: {'x-rapidapi-host': _hostStateData, 'x-rapidapi-key': _key});
      _response = _responseCheck(_response);
    } on SocketException {
      throw TooManyRequests("Not connected to internet");
    }
    return _response;
  }

  dynamic _responseCheck(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return response;

      case 400:
        throw BadRequestException(response.body.toString());
      
      case 429:
        throw TooManyRequests(response.body.toString());

      case 401:

      case 403:
        break;

      case 500:
        throw IntervalServerException();

      default:
        throw TooManyRequests(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
