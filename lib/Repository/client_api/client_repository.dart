import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/LoginDto.dart';

abstract class ClientRepository {

  Future<ApiResponse<Client>> getClient(int Id);

}