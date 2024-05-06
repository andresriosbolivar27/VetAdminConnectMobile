import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Repository/city_api/city_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class CityHttpApiRepository implements CityRepository {
  final BaseService<List<City>> _apiServices = NetworkApiService("City");

  @override
  Future<ApiResponse<List<City>>> getCombo(int id,String token) async {
    var endpoint = AppUrl.getCityComboEndpoint;
    final response = await _apiServices.getResponse(
        '$endpoint$id', token );
    return response;
  }
}