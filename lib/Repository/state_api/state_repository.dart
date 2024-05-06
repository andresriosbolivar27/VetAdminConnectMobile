import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';

abstract class StateRepository {

  Future<ApiResponse<List<Departamento>>> getCombo(int id, String token);
}