import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';
import 'package:vetadminconnectmobile/Repository/vet_api/vet_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class VetHttpApiRepository extends VetRepository{
  final BaseService<List<Vet>> _apiServices = NetworkApiService("Vet");

  @override
  Future<ApiResponse<List<Vet>>> getVets(PaginationDto data, String token) async {

    var endpoint = AppUrl.getVetsEndpoint;
    Map<String, String> queryParams = {
      'Page': data.page.toString(),
      'RecordsNumber': data.recordsNumber.toString(),
    };

    if (data.id != null) {
      queryParams['Id'] = data.id.toString();
    }
    if(data.filter!.isNotEmpty){
      queryParams['Filter'] = data.filter.toString();
    }

    final Uri uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
    final response = await _apiServices.getResponse(
        uri.toString(), token);
    return response;
  }

}