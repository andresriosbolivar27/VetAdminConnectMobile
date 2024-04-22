
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Generic/exception_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';



void main() {
  group('ApiResponse test', () {
    final jsonString = '''
    {
      "wasSuccess": true,
      "message": null,
      "result": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "expiration": "2024-05-20T04:40:11.4838162Z",
        "result": true
      },
      "exceptions": [
        {
          "severityException": 0,
          "exception": "El campo Contraseña debe tener al menos 6 caracteres."
        }
      ]
    }
    ''';

    // test('deserialization', () {
    //   final deserialized = ApiResponse.fromJson(
    //       Map<String, dynamic>.from(jsonDecode(jsonString)), (json) {
    //     // Assume 'UserData' class for the result based on your structure
    //     if (json is Map<String, dynamic>) {
    //       return  TokenResult.empty().fromJson(json);
    //     } else {
    //       throw Exception('Unsupported result type: ${json.runtimeType}');
    //     }
    //   });
    //
    //   expect(deserialized.wasSuccess, true);
    //   expect(deserialized.message, null);
    //   expect(deserialized.exceptions!.length, 1);
    //   expect(deserialized.exceptions!.first.severityException.index, 0);
    //   expect(deserialized.exceptions!.first.exception,
    //       'El campo Contraseña debe tener al menos 6 caracteres.');
    //
    //   // Access the actual 'UserData' object if applicable
    //   if (deserialized.result is TokenResult) {
    //     final userData = deserialized.result as TokenResult;
    //     // Perform assertions on UserData properties
    //   }
    // });

    test('serialization', () {
      final deserialized = ApiResponse.fromJson(
          Map<String, dynamic>.from(jsonDecode(jsonString)), (json) {
        // Assume 'UserData' class for the result based on your structure
        if (json is Map<String, dynamic>) {
          return  TokenResult.empty().fromJson(json);
        } else {
          throw Exception('Unsupported result type: ${json.runtimeType}');
        }
      });

      final expectedJson = jsonEncode({
        "wasSuccess": true,
        "message": null,
        "result": {
          "token": "...", // Truncated token for brevity
          "expiration": "2024-05-20T04:40:11.4838162Z",
          "result": true
        },
        "exceptions": [
          {"severityException": 0, "exception": "El campo Contraseña debe tener al menos 6 caracteres."}
        ]
      });

      final serialized = deserialized.toJson();
      expect(jsonEncode(serialized), expectedJson);
    });
  });


}