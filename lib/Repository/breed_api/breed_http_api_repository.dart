import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/Raza.dart';
import 'package:vetadminconnectmobile/Repository/breed_api/breed_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class BreedHttpApiRepository implements BreedRepository {
  final BaseService<List<Raza>> _apiServices = NetworkApiService("Breed");

  @override
  Future<ApiResponse<List<Raza>>> getCombo(int id, String token) async {
    var endpoint = AppUrl.getBreedComboEndpoint;
    final response = await _apiServices.getResponse(
        '$endpoint$id', token);
    return response;
  }
}