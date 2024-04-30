import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class ClientHttpApiRepository implements ClientRepository {
final BaseService<Client> _apiServices = NetworkApiService("Client");

  @override
  Future<ApiResponse<Client>> getClient(int id) async {
    var endpoint = AppUrl.getClientEndpoint;
    final response = await _apiServices.getResponse(
        '$endpoint$id');
    return response;
  }
}