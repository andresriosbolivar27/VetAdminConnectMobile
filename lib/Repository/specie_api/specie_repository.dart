import 'package:vetadminconnectmobile/Model/Especie.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';

abstract class SpecieRepository {

  Future<ApiResponse<List<Especie>>> getCombo();
}