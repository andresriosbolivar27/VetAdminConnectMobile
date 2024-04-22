import 'package:json_annotation/json_annotation.dart';
import 'package:vetadminconnectmobile/Model/Generic/exception_response.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool wasSuccess;
  final String? message;
  final T? result;
  final List<ExceptionResponse>? exceptions;

  ApiResponse({
    required this.wasSuccess,
    this.message,
    this.result,
    this.exceptions,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson() => _$ApiResponseToJson<T>(this, (value) => this.result);


}