import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';

abstract class VetRepository{
  Future<ApiResponse<List<Vet>>> getVets(PaginationDto data, String token);
}