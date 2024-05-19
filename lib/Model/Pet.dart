import 'Enums.dart';

class Pet {
  int? clientId;
  int? id;
  String name;
  int age;
  int genderType;
  String? genderTypeDescription;
  int sizeType;
  String? sizeTypeDescription;
  int specieId;
  String? specieName;
  int breedId;
  String? breedName;
  String? photo;

  Pet({
    this.clientId,
    this.id,
    required this.name,
    required this.age,
    required this.genderType,
    this.genderTypeDescription,
    required this.sizeType,
    this.sizeTypeDescription,
    required this.specieId,
    this.specieName,
    required this.breedId,
    this.breedName,
    this.photo,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
      clientId: json['clientId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      genderType: json['genderType'] as int,
      genderTypeDescription: json['genderTypeDescription'] as String,
      sizeType: json['sizeType'] as int,
      sizeTypeDescription: json['sizeTypeDescription'] as String,
      specieId: json['specieId'] as int,
      specieName: json['specieName'] as String,
      breedId: json['breedId'] as int,
      breedName: json['breedName'] as String,
      photo: json['photo'] as String?);

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'id': id,
        'name': name,
        'age': age,
        'genderType': genderType,
        'genderTypeDescription': genderTypeDescription,
        'sizeType': sizeType,
        'sizeTypeDescription': sizeTypeDescription,
        'specieId': specieId,
        'specieName': specieName,
        'breedId': breedId,
        'breedName': breedName,
        'photo': photo,
      };

  int? get petClientId => clientId;
  int? get petId => id;
  String get petName => name;
  int get petAge => age;
  int get petGenderType => genderType;
  String? get petGenderTypeDescription => genderTypeDescription;
  int get petSizeType => sizeType;
  String? get petSizeTypeDescription => sizeTypeDescription;
  int get petSpecieId => specieId;
  String? get petSpecieName => specieName;
  int get petBreedId => breedId;
  String? get petBreedName => breedName;

  void set petClientId(int? newClientId) {
    clientId = newClientId;
  }

  void set petId(int? newId) {
    id = newId;
  }

  void set petName(String newName) {
    name = newName;
  }

  void set petAge(int newAge) {
    age = newAge;
  }

  void set petGenderType(int newGenderType) {
    genderType = newGenderType;
  }

  void set petGenderTypeDescription(String? newGenderTypeDescription) {
    genderTypeDescription = newGenderTypeDescription;
  }

  void set petSizeType(int newSizeType) {
    sizeType = newSizeType;
  }

  void set petSizeTypeDescription(String? newSizeTypeDescription) {
    sizeTypeDescription = newSizeTypeDescription;
  }

  void set petSpecieId(int newSpecieId) {
    specieId = newSpecieId;
  }

  void set petSpecieName(String? newSpecieName) {
    specieName = newSpecieName;
  }

  void set petBreedId(int newBreedId) {
    breedId = newBreedId;
  }

  void set petBreedName(String? newBreedName) {
    breedName = newBreedName;
  }
}
