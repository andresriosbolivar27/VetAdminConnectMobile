import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';

abstract class AuthRepository {

  Future<TokenResult> loginApi(LoginDto data);

}