import 'Enums.dart';

class Pet {
  int _id;
  String _name;
  int _age;
  GenderType _genderType;
  SizeType _sizeType;
  int _specieId;
  int _breedId;
  int _clientId;
  String? _photo;

  Pet(
      this._id,
      this._name,
      this._age,
      this._genderType,
      this._sizeType,
      this._specieId,
      this._breedId,
      this._clientId,
      this._photo,
      );

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  GenderType get genderType => _genderType;

  set genderType(GenderType value) {
    _genderType = value;
  }

  SizeType get sizeType => _sizeType;

  set sizeType(SizeType value) {
    _sizeType = value;
  }

  int get specieId => _specieId;

  set specieId(int value) {
    _specieId = value;
  }

  int get breedId => _breedId;

  set breedId(int value) {
    _breedId = value;
  }

  int get clientId => _clientId;

  set clientId(int value) {
    _clientId = value;
  }

  String? get photo => _photo;

  set photo(String? value) {
    _photo = value;
  }
}
