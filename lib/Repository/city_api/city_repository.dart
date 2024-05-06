import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';

abstract class CityRepository {

  Future<ApiResponse<List<City>>> getCombo(int id, String token);
}