abstract class BaseService {
  Future<dynamic> getResponse(String url);
  Future<dynamic> getPostApiResponse(String url , dynamic data);

}