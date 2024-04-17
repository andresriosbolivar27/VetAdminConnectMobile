import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class AuthHttpApiRepository implements AuthRepository{
  final BaseService _apiServices = NetworkApiService();

  @override
  Future<TokenResult> loginApi(LoginDto data )async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data.toJson());
    TokenResult result = TokenResult.empty();
    return result.fromJson(response) ;
  }
}