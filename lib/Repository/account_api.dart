import 'package:vetadminconnectmobile/Services/account_service.dart';

import '../Services/base_service.dart';

class AccountApi{
  BaseService accountService = AccountService();

  // Future<List<Media>> fetchMediaList(String value) async {
  //   dynamic response = await _mediaService.getResponse(value);
  //   final jsonData = response['results'] as List;
  //   List<Media> mediaList =
  //   jsonData.map((tagJson) => Media.fromJson(tagJson)).toList();
  //   return mediaList;
  // }
}