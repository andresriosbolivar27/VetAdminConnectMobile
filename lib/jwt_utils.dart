import 'package:jwt_decoder/jwt_decoder.dart';

class JwtUtils {
  static Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}