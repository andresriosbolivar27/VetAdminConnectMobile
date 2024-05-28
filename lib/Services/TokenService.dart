import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Repository/auth_api/auth_http_api_repository.dart';

class TokenService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final _authService = AuthHttpApiRepository();

  Future<void> saveSecureData(Map<String, dynamic> data, String key) async {
    final tokenJson = json.encode(data);
    await _secureStorage.write(key: key, value: tokenJson);
  }

  Future<void> deleteSecureData() async {
    await _secureStorage.deleteAll();
  }

  Future<Map<String, dynamic>> getTokenData(String keyData) async {
    final tokenJson = await _secureStorage.read(key: keyData);
    if (tokenJson != null) {
      return Map<String, dynamic>.from(json.decode(tokenJson));
    } else {
      return {};
    }
  }

  Future<ApiResponse<TokenResult>> loginAndSaveToken(LoginDto loginDto, BuildContext context) async {
    final result = await _authService.loginApi(loginDto,'');
    if (!result.wasSuccess) {
      _showMsg(result.exceptions!.first.exception, context);
    }
      final token = result.result!.token;
      final decodedToken = JwtDecoder.decode(token);
      await saveSecureData(decodedToken, 'token');
      await saveSecureData(loginDto.toJson(), 'loginDto');

      return result;
  }

  Future<void> validateAndRefreshToken(BuildContext context) async {
    final tokenData = await getTokenData('token');
    if (tokenData.isNotEmpty) {
      final exp = tokenData['exp'];
      if (exp != null) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (now >= exp) {
          try {
            final loginDto = await getTokenData('loginDto');
            LoginDto loginRequest = LoginDto(email: loginDto['email'], password: loginDto['password']);
            await loginAndSaveToken(loginRequest,context);
          } catch (e) {
            debugPrint('Error al renovar el token: $e');
          }
        }
      }
    }
  }

  void _showMsg(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> updateSecureData(Map<String, dynamic> newData, String key) async {
    final tokenJson = await _secureStorage.read(key: key);
    if (tokenJson != null) {
      final existingData = Map<String, dynamic>.from(json.decode(tokenJson));
      existingData.addAll(newData); // Actualiza los datos existentes con los nuevos datos
      final updatedTokenJson = json.encode(existingData);
      await _secureStorage.write(key: key, value: updatedTokenJson);
    } else {
      throw Exception('No se encontraron datos para la llave especificada: $key');
    }
  }
}
