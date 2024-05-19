import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Especie.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';
import 'package:vetadminconnectmobile/Repository/specie_api/specie_repository.dart';
import 'package:vetadminconnectmobile/Repository/state_api/state_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class SpecieHttpApiRepository implements SpecieRepository {
  final BaseService<List<Especie>> _apiServices = NetworkApiService("Specie");

  @override
  Future<ApiResponse<List<Especie>>> getCombo() async {
    var endpoint = AppUrl.getSpecieComboEndpoint;
    final response = await _apiServices.getResponse(
        endpoint,'');
    return response;
  }
}