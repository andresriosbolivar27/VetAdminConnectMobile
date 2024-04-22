// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      wasSuccess: json['wasSuccess'] as bool,
      message: json['message'] as String?,
      result: _$nullableGenericFromJson(json['result'], fromJsonT),
      exceptions: (json['exceptions'] as List<dynamic>?)
          ?.map((e) => ExceptionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'wasSuccess': instance.wasSuccess,
      'message': instance.message,
      'result': _$nullableGenericToJson(instance.result, toJsonT),
      'exceptions': instance.exceptions,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
