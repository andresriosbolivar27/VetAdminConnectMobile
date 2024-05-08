import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class AuthHttpApiRepository implements AuthRepository {
  final BaseService<TokenResult> _apiServices =
      NetworkApiService("TokenResult");

  @override
  Future<ApiResponse<TokenResult>> loginApi(LoginDto data, String token) async {
    final response = await _apiServices.getPostApiResponse(
        AppUrl.loginEndPoint, data.toJson(), token);
    return response;
  }

  @override
  Future<ApiResponse<TokenResult>> createClientApi(Client ata, String token) async {
    // TODO: implement CreateClientApi
    throw UnimplementedError();
  }
}
