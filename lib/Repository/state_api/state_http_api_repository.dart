import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';
import 'package:vetadminconnectmobile/Repository/state_api/state_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class StateHttpApiRepository implements StateRepository {
  final BaseService<List<Departamento>> _apiServices = NetworkApiService("State");

  @override
  Future<ApiResponse<List<Departamento>>> getCombo(int id, String token) async {
    var endpoint = AppUrl.getStateComboEndpoint;
    final response = await _apiServices.getResponse(
        '$endpoint$id', token);
    return response;
  }
}