import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';

abstract class CountryRepository {

  Future<ApiResponse<List<Country>>> getCombo(String token);
}