import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:vetadminconnectmobile/configs/app_url.dart';
import '../Model/Generic/app_exception.dart';
import 'base_service.dart';

class NetworkApiService extends BaseService {
  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    if (kDebugMode) {
      print(url);
    }
    try {
      final response = await http.get(Uri.parse(AppUrl.baseUrl + url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url , dynamic data) async{


    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson ;
    try {

      http.Response response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: data
      ).timeout( const Duration(seconds: 10));

      responseJson = returnResponse(response);
    }on SocketException {
      throw NoInternetException('No Internet Connection');
    }on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson ;
  }

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}