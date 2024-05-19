class Raza {
  int id;
  String name;
  int specieId;

  Raza({required this.id, required this.name, required this.specieId});

  factory Raza.fromJson(Map<String, dynamic> json) {
    return Raza(
      id: json['id'],
      name: json['name'],
      specieId: json['specieId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['specieId'] = this.specieId;
    return data;
  }

  int get getId => id;
  String get getName => name;
  int get getSpecieId => specieId;

  set setId(int id) => this.id = id;
  set setName(String name) => this.name = name;
  set setSpecieId(int specieId) => this.specieId = specieId;
}