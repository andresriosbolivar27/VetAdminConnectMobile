import 'package:vetadminconnectmobile/Model/Generic/BaseModel.dart';

class TokenResult extends BaseModel<TokenResult> {
  final String token;
  final String expiration;
  final bool result;

  TokenResult({required this.token, required this.expiration, required this.result});
  TokenResult.empty()
      : token = '',
        expiration = '',
        result = false;


  @override
  Map<String, Object?> toJson() {
    return {
      'token': token,
      'expiration': expiration,
      'result' : result
    };
  }

  @override
  TokenResult fromJson(Map<String, dynamic> json) {
    return TokenResult(
      token: json['token'] as String ?? '',
      expiration: json['expiration'] as String ?? '' ,
      result: json['result'] as bool
    );
  }
}