import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Pet.dart';
import 'package:vetadminconnectmobile/Model/User.dart';

class Client extends User {
  int _clientId;
  List<Pet> _pets;

  int get clientId => _clientId;
  set clientId(int value) => _clientId = value;

  List<Pet> get pets => _pets;
  set pets(List<Pet> value) => _pets = value;

  Client(
      String id,
      String document,
      String firstName,
      String lastName,
      String address,
      String? photo,
      int userType,
      int cityId,
      String cityName,
      String userName,
      String email,
      String? password,
      String? passwordConfirm,
      String phoneNumber,
      int clientId,
      List<Pet> pets,
      )   : _clientId = clientId,
        _pets = pets,
        super(
        id,
        document,
        firstName,
        lastName,
        address,
        photo,
        userType,
        cityId,
        cityName,
        userName,
        email,
        password,
        passwordConfirm,
        phoneNumber,
      );

  // Constructor vacío
  Client.empty()
      : _clientId = 0,
        _pets = [],
        super(
        '',
        '',
        '',
        '',
        '',
        null,
        0,
        0,
        '',
        '',
        '',
        null,
        null,
        '',
      );

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      json['id'],
      json['document'],
      json['firstName'],
      json['lastName'],
      json['address'],
      json['photo'],
      json['userType'],
      json['cityId'],
      json['cityName'],
      json['email'],
      json['email'],
      json['password'],
      json['passwordConfirm'],
      json['phoneNumber'],
      json['clientId'],
      (json['pets'] as List<dynamic>)
          .map((petJson) => Pet.fromJson(petJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'photo': photo,
      'userType': userType,
      'cityId': cityId,
      'cityName': cityName,
      'userName': userName,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'phoneNumber': phoneNumber,
      'clientId': clientId,
      'pets': pets.map((pet) => pet.toJson()).toList(),
    };
  }
}
