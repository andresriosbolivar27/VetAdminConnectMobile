import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Review.dart';
import 'package:vetadminconnectmobile/Repository/review_api/review_repository.dart';
import 'package:vetadminconnectmobile/Services/base_service.dart';
import 'package:vetadminconnectmobile/Services/network_api_services.dart';
import 'package:vetadminconnectmobile/configs/app_url.dart';

class ReviewHttpApiRepository extends Reviewrepository{

  @override
  Future<ApiResponse<Review>> addReview(Review review, String token) async{
    final BaseService<Review> _apiServices = NetworkApiService("String");

    final response = await _apiServices.getPostApiResponse(
        AppUrl.addReviewsApiEndPoint, review.toJson(), token);
    return response;
  }

  @override
  Future<ApiResponse<List<Review>>> getReviews(PaginationDto data, String token) async {
    final BaseService<List<Review>> apiServices = NetworkApiService("Review");

    var endpoint = AppUrl.getReviewsEndpoint;
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
    final response = await apiServices.getResponse(
        uri.toString(), token);
    return response;
  }
}