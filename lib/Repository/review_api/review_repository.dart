import 'package:vetadminconnectmobile/Model/Generic/api_response.dart';
import 'package:vetadminconnectmobile/Model/PaginationDto.dart';
import 'package:vetadminconnectmobile/Model/Review.dart';

abstract class Reviewrepository{
  Future<ApiResponse<Review>> addReview(Review review, String token);
  Future<ApiResponse<List<Review>>> getReviews(PaginationDto data, String token);
}