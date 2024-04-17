import 'dart:convert';

import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_repository.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

import '../Services/base_service.dart';

class AuthApiRepository implements AuthRepository
{
  final BaseService _apiServices = NetworkApiService();

  @override
  Future<TokenResult> loginApi(LoginDto data )async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, jsonEncode(data));
    return TokenResult.empty().fromJson(response) ;
  }
}