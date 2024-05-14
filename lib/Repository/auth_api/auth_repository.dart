import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';

abstract class AuthRepository {

  Future<ApiResponse<TokenResult>> loginApi(LoginDto data, String token);
  Future<ApiResponse<String>> createClientApi(Client data, String token);

}