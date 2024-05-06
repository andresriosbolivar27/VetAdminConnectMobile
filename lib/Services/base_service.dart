import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';

abstract class BaseService<T> {
  Future<ApiResponse<T>>getResponse(String url, String bearerToken);

  Future<ApiResponse<T>> getPostApiResponse(String url , Map<String, dynamic> data, String bearerToken);

}