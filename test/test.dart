import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Generic/exception_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/TokenResult.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';
import 'package:vetadminconnectmobile/Repository/vet_api/vet_http_api_repository.dart';

void main() {
  //deserializeApiResponseTest();

  //getUriVets();
  getVets();
}

void getVets() async {
  group('Obtener Veterinarios', () {
    test('Obtener lista de veterinarios', () async {
      var pagination = PaginationDto(null, 1, 10, '');
      var vetApi = VetHttpApiRepository();
      try {
        var response = await vetApi.getVets(pagination, '');
        if (response.wasSuccess) {
          print('Solicitud exitosa');
        } else {
          print('Error en la solicitud: ${response.exceptions}');
        }
      } catch (ex) {
        print('Error al realizar la solicitud: $ex');
      }
    });
  });
}

void getUriVets() {
  group('Obtener Veterinarios', () {
    final Map<String, String> queryParams = {
      'Id': '1',
      'Page': '1',
      'RecordsNumber': '5',
      'Filter': ''
    };
    Uri uri = Uri.parse('http://192.168.10.22:82/api/Vets')
        .replace(queryParameters: queryParams);
    print(uri.toString());
  });
}

void deserializeApiResponseTest() {
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
          return TokenResult.empty().fromJson(json);
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
          {
            "severityException": 0,
            "exception": "El campo Contraseña debe tener al menos 6 caracteres."
          }
        ]
      });

      final serialized = deserialized.toJson();
      expect(jsonEncode(serialized), expectedJson);
    });
  });
}
