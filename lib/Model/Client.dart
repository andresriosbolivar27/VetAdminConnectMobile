import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Model/User.dart';

class Client extends User {
  late int _clientId;
  late Pet _pet;

  Pet get pet => _pet;

  set pet(Pet value) {
    _pet = value;
  }

  int get clientId => _clientId;

  set clientId(int value) {
    _clientId = value;
  }

  Client(
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
