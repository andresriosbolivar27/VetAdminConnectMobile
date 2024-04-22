import 'package:vetadminconnectmobile/Model/Dictionaries.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';

class ExceptionResponse{
  SeverityException severityException;
  String exception;

  ExceptionResponse({
    required this.severityException,
    required this.exception,
  });

  factory ExceptionResponse.fromJson(Map<String, dynamic> json) {
    String severityExceptionString = json['exception'] ?? '';
    SeverityException severityException = severityExceptionMap.containsKey(json['severityException'].toString())
        ? severityExceptionMap[json['severityException'].toString()]!
        : SeverityException.Information;

    return ExceptionResponse(
      severityException: severityException,
      exception: json['exception'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severityException': severityException.toString(),
      'exception': exception,
    };
  }
}