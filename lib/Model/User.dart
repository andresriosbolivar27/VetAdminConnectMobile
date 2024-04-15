import 'package:vetadminconnectmobile/Model/Enums.dart';

class User {
  String _id;
  String _document;
  String _firstName;
  String _lastName;
  String _address;
  String? _photo;
  UserType _userType;
  int _cityId;
  String _userName;
  String _email;
  String _password;
  String _passwordConfirm;
  String _phoneNumber;

  User(
      this._id,
      this._document,
      this._firstName,
      this._lastName,
      this._address,
      this._photo,
      this._userType,
      this._cityId,
      this._userName,
      this._email,
      this._password,
      this._passwordConfirm,
      this._phoneNumber
  );

  User.empty() :
        _id = '',
        _document = '',
        _firstName = '',
        _lastName = '',
        _address = '',
        _photo = null,
        _userType = UserType.anonymous,
        _cityId = 0,
        _userName = '',
        _email = '',
        _password = '',
        _passwordConfirm = '',
        _phoneNumber = '';

  String get fullName => '$firstName $lastName';
  String get id => _id;
  String get document => _document;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get address => _address;
  String? get photo => _photo;
  UserType get userType => _userType;
  int get cityId => _cityId;
  String get userName => _userName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get passwordConfirm => _passwordConfirm;
  String get password => _password;

  set id(String value) {
    _id = value;
  }
  set document(String value) {
    _document = value;
  }
  set firstName(String value) {
    _firstName = value;
  }
  set lastName(String value) {
    _lastName = value;
  }
  set address(String value) {
    _address = value;
  }
  set photo(String? value) {
    _photo = value;
  }
  set userType(UserType value) {
    _userType = value;
  }
  set cityId(int value) {
    _cityId = value;
  }
  set userName(String value) {
    _userName = value;
  }
  set email(String value) {
    _email = value;
  }
  set phoneNumber(String value) {
    _phoneNumber = value;
  }
  set passwordConfirm(String value) {
    _passwordConfirm = value;
  }
  set password(String value) {
    _password = value;
  }

  Map<String, dynamic> toJson() => {
    'id': _id,
    'document': _document,
    'firstName': _firstName,
    'lastName': _lastName,
    'address': _address,
    'photo': _photo,
    'userType': _userType.toString().split('.').last,
    'cityId': _cityId,
    'userName': _userName,
    'email': _email,
    'password': _password,
    'passwordConfirm': _passwordConfirm,
    'phoneNumber': _phoneNumber,
  };

  User.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _document = json['document'],
        _firstName = json['firstName'],
        _lastName = json['lastName'],
        _address = json['address'],
        _photo = json['photo'],
        _userType = UserType.values
            .firstWhere((type) => type.index == json['userType']),
        _cityId = json['cityId'],
        _userName = json['userName'],
        _email = json['email'],
        _password = json['password'],
        _passwordConfirm = json['passwordConfirm'],
        _phoneNumber = json['phoneNumber'];
}

