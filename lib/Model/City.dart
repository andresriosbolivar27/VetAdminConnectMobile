import 'package:vetadminconnectmobile/Model/Generic/BaseModel.dart';

class City {
  int _id;
  String _name;

  int get id => _id;
  String get name => _name;

  set id(int value) {
    _id = value;
  }
  set name(String value) {
    _name = value;
  }

  City(
    this._id,
    this._name,
  );

  City.empty()
      : _id = 0,
        _name = '';


  factory City.fromJson(Map<String, dynamic> json) =>
      City(
          json['id'] as int,
          json['name'] as String);


  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name
  };
}
