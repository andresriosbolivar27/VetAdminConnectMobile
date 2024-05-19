import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Repository/client_api/client_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class ClientHttpApiRepository implements ClientRepository {

  @override
  Future<ApiResponse<Client>> getClient(String id, String token) async {
    final BaseService<Client> _apiServices = NetworkApiService("Client");
    var endpoint = AppUrl.getClientEndpoint;
    final response = await _apiServices.getResponse(
        '$endpoint$id', token);
    return response;
  }

  @override
  Future<ApiResponse<String>> addPets(Client client, String token) async{
    final BaseService<String> apiServices;
    apiServices = NetworkApiService("NewPets");
    final response = await apiServices.getPostApiResponse(
        AppUrl.addPetsApiEndPoint, client.toJson(), token);
    return response;
  }
}