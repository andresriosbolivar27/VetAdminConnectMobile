import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/User.dart';

class Vet extends User {
  late int _vetId;

  int get vetId => _vetId;

  set vetId(int value) {
    _vetId = value;
  }

  Vet(
    String id,
    String document,
    String firstName,
    String lastName,
    String address,
    String photo,
    String userType,
    int cityId,
    String userName,
    String email,
    String password,
    String passwordConfirm,
    String phoneNumber,
  ) : super(
          id,
          document,
          firstName,
          lastName,
          address,
          photo,
          userType as UserType,
          cityId,
          userName,
          email,
          password,
          passwordConfirm,
          phoneNumber,
        );
}
