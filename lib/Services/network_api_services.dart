import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Generic/exception_response.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import '../Model/Generic/app_exception.dart';
import 'base_service.dart';

class NetworkApiService<T> extends BaseService<T> {
  final String typeName;
  NetworkApiService(this.typeName);
  @override
  Future<ApiResponse<T>> getResponse(String url, String bearerToken) async {
    if (kDebugMode) {
      print(url);
    }
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      if (bearerToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }
      final response = await http.get(
          Uri.parse(url),
          headers: headers
          );
      return _handleResponse<T>(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future<ApiResponse<T>> getPostApiResponse(String url, Map<String, dynamic> data, String bearerToken) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      if (bearerToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data), // Encode data as JSON
      ).timeout(const Duration(seconds: 10));
      return _handleResponse<T>(response);
    } on SocketException {
      throw NoInternetException("No Internet Connection");
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } on FormatException catch (e) {
      throw e.toString();
    } catch (e) {
      // Catch-all for unexpected exceptions
      print('Error fetching data: $e');
      rethrow; // Re-throw to propagate the error
    }
  }

  @visibleForTesting
  Future<ApiResponse<T>> _handleResponse<T>(http.Response response) async {
    final responseJson = jsonDecode(response.body);
    final value = getTipoGenerico(response.body);
    switch (response.statusCode) {
      case 200:
        return ApiResponse.fromJson(responseJson, (p0) => value.result as T);
      case 400:
        final objectResponse = ApiResponse.fromJson(responseJson, (p0) => null);
        return ApiResponse<T>(wasSuccess: false, message: response.body.toString(),
            exceptions: objectResponse.exceptions);
      case 401:
      case 403:
        return ApiResponse<T>(wasSuccess: false, message: "",
            exceptions: [
              ExceptionResponse(severityException: SeverityException.Error, exception: "Solicitud no autorizada")
            ]);
      case 500:
      default:
        return ApiResponse<T>(
            wasSuccess: false,
            message: 'Error occured while communication with server with status code : ${response.statusCode}',
            exceptions: [
              ExceptionResponse(severityException: SeverityException.Error, exception: "Error interno del servidor")
            ]);
    }
  }

  ApiResponse<dynamic>  getTipoGenerico(String json) {
    final deserialized = ApiResponse.fromJson(
        Map<String, dynamic>.from(jsonDecode(json)), (json) {
      // Assume 'UserData' class for the result based on your structure
      if (json is Map<String, dynamic>) {
        if(typeName == "TokenResult"){
          return TokenResult.empty().fromJson(json);
        }
        if(typeName == "Client"){
          return Client.fromJson(json);
        }
        if(typeName == "Country"){
          return Country.fromJson(json);
        }
      }if(json is List<dynamic>){
        if(typeName == "Country"){
          return json.map((json) => Country.fromJson(json)).toList();
        }
        if(typeName == "State"){
          return json.map((json) => Departamento.fromJson(json)).toList();
        }
        if(typeName == "City"){
          return json.map((json) => City.fromJson(json)).toList();
        }
      }
      else {
        throw Exception('Unsupported result type: ${json.runtimeType}');
      }
    });
    return deserialized;
  }
}