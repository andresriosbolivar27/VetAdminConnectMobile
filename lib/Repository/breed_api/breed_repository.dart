import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Raza.dart';

abstract class BreedRepository {

  Future<ApiResponse<List<Raza>>> getCombo(int id, String token);
}