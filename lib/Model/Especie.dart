class Especie {
  late int id;
  late String name;
  late String description;
  late int breedsNumber;

  Especie({
    required this.id,
    required this.name,
    required this.description,
    required this.breedsNumber,
  });

  factory Especie.fromJson(Map<String, dynamic> json) {
    return Especie(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      breedsNumber: json['breedsNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['breedsNumber'] = breedsNumber;
    return data;
  }

  // Getters and Setters

  int getId() {
    return id;
  }

  void setId(int id) {
    this.id = id;
  }

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getDescription() {
    return description;
  }

  void setDescription(String description) {
    this.description = description;
  }

  int getBreedsNumber() {
    return breedsNumber;
  }

  void setBreedsNumber(int breedsNumber) {
    this.breedsNumber = breedsNumber;
  }
}
