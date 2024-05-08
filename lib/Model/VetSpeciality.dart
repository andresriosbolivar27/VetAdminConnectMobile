class VetSpeciality {
  int _specialityId;
  String _name;
  String _description;

  int get specialityId => _specialityId;
  String get name => _name;
  String get description => _description;

  set specialityId(int value) {
    _specialityId = value;
  }

  set description(String value) {
    _description = value;
  }

  set name(String value) {
    _name = value;
  }

  VetSpeciality(
    this._specialityId,
    this._name,
    this._description,
  );

  factory VetSpeciality.fromJson(Map<String, dynamic> json) {
    return VetSpeciality(
      json['specialityId'] as int,
      json['name'] as String,
      json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return{
    'specialityId' : _specialityId,
    'name' : _name,
    'description' : _description
  };
  }
}