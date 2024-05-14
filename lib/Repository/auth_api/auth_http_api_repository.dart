import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class AuthHttpApiRepository implements AuthRepository {



  @override
  Future<ApiResponse<TokenResult>> loginApi(LoginDto data, String token) async {
    late BaseService<TokenResult> apiServices;
    apiServices = NetworkApiService("TokenResult");
     final response = await apiServices.getPostApiResponse(
        AppUrl.loginEndPoint, data.toJson(), token);
    return response;
  }

  @override
  Future<ApiResponse<String>> createClientApi(Client data, String token) async {
    late BaseService<String> apiServices;
    apiServices = NetworkApiService("NewClient");
    final response = await apiServices.getPostApiResponse(
        AppUrl.registerApiEndPoint, data.toJson(), token);
    return response;
  }
}
