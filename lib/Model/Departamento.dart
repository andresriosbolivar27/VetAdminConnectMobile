import 'package:vetadminconnectmobile/Model/City.dart';
import 'package:vetadminconnectmobile/Model/Generic/BaseModel.dart';

class Departamento {
  int _id;
  String _name;
  List<City>? _cities;
  int _citiesNumber;

  Departamento(
    this._id,
    this._name,
    this._citiesNumber,
    this._cities,
  );

  String get name => _name;
  List<City>? get cities => _cities;
  int get citiesNumber => _citiesNumber;
  int get id => _id;

  set id(int value) {
    _id = value;
  }

  set cities(List<City>? value) {
    _cities = value;
  }

  set name(String value) {
    _name = value;
  }

  set citiesNumber(int value) {
    _citiesNumber = value;
  }

  Departamento.empty()
      : _id = 0,
        _name = '',
        _citiesNumber = 0,
        _cities = [];


  factory Departamento.fromJson(Map<String, dynamic> json) => Departamento(
        json['id'] as int,
        json['name'] as String,
        json['citiesNumber'] ?? 0,
        (json['cities'] as List<dynamic>?)?.map((city) => City.fromJson(city))
            .toList(),
      );


  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'statesNumber': _citiesNumber,
        'states': _cities?.map((city) => city.toJson()).toList(),
      };
}
