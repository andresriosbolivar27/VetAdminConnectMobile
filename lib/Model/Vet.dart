import 'package:vetadminconnectmobile/Model/Appointment.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/User.dart';
import 'package:vetadminconnectmobile/Model/VetSpeciality.dart';

class Vet extends User {
  late int _vetId;
  late List<VetSpeciality> _vetSpecialities;

  List<VetSpeciality> get vetSpecialities => _vetSpecialities;

  set vetSpecialities(List<VetSpeciality> value) {
    _vetSpecialities = value;
  }

  List<Appointment>? appointments;

  int get vetId => _vetId;

  set vetId(int value) {
    _vetId = value;
  }

  Vet(
      super.id,
      super.document,
      super.firstName,
      super.lastName,
      super.address,
      super.photo,
      super.userType,
      super.cityId,
      super.userName,
      super.email,
      super.password,
      super.passwordConfirm,
      super.phoneNumber,
      int vetId,
      List<VetSpeciality> vetSpecialitiesList
      ) :  _vetId = vetId , _vetSpecialities =vetSpecialitiesList ;


  factory Vet.fromJson(Map<String, dynamic> json) {
    var vetSpecialitiesJsonList = json['vetSpecialities'] as List<dynamic>;
    List<VetSpeciality> vetSpecialities = vetSpecialitiesJsonList
        .map((vetSpecialityJson) => VetSpeciality.fromJson(vetSpecialityJson))
        .toList();

    return Vet(
      json['id'],
      json['document'],
      json['firstName'],
      json['lastName'],
      json['address'],
      json['photo'],
      json['userType'],
      json['cityId'],
      json['userName'],
      json['email'],
      json['password'],
      json['passwordConfirm'],
      json['phoneNumber'],
      json['vetId'],
      vetSpecialities,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> vetSpecialitiesJsonList = _vetSpecialities
        .map((vetSpeciality) => vetSpeciality.toJson())
        .toList();

    return {
      'id': id,
      'document': document,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'photo': photo,
      'userType': userType,
      'cityId': cityId,
      'userName': userName,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'phoneNumber': phoneNumber,
      'vetId': vetId,
      'vetSpecialities': vetSpecialitiesJsonList,
    };
  }
}
