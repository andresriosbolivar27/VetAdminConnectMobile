import 'package:vetadminconnectmobile/Model/Generic/BaseModel.dart';
import 'package:vetadminconnectmobile/Model/Departamento.dart';

class Country {
  int _id;
  String _name;
  List<Departamento>? _states;
  int? _statesNumber;

  Country(
    this._id,
    this._name,
    this._statesNumber,
    this._states,
  );

  int get id => _id;
  String get name => _name;
  List<Departamento>? get states => _states;
  int? get statesNumber => _statesNumber;

  set name(String value) {
    _name = value;
  }

  set statesNumber(int? value) {
    _statesNumber = value;
  }

  set states(List<Departamento>? value) {
    _states = value;
  }

  set id(int value) {
    _id = value;
  }

  Country.empty()
      : _id = 0,
        _name = '',
        _statesNumber = 0,
        _states = [];


  factory Country.fromJson(Map<String, dynamic> json) => Country(
        json['id'] as int,
        json['name'] as String,
        json['_statesNumber'] ?? 0,
        (json['states'] as List<dynamic>?)?.map((state) => Departamento.fromJson(state)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'statesNumber': _statesNumber,
        'states': _states?.map((state) => state.toJson()).toList(),
      };
}
