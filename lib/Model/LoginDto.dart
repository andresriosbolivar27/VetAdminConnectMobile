import 'package:vetadminconnectmobile/Model/Generic/BaseModel.dart';

class LoginDto extends BaseModel<LoginDto> {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});

  @override
  Map<String, Object?> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  LoginDto fromJson(Map<String, dynamic> json) {
    return LoginDto(
      email: json['email'] as String ?? '',
      password: json['password'] as String ?? '' ,
    );
  }
}
