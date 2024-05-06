
import 'package:vetadminconnectmobile/Model/Country.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Repository/country_api/country_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class CountryHttpApiRepository implements CountryRepository {
  final BaseService<List<Country>> _apiServices = NetworkApiService("Country");

  @override
  Future<ApiResponse<List<Country>>> getCombo(String token) async {
    var endpoint = AppUrl.getCountryComboEndpoint;
    final response = await _apiServices.getResponse(endpoint, token);
    return response;
  }
}