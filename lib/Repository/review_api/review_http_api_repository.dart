import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
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
}