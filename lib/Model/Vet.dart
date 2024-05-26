import 'package:vetadminconnectmobile/Model/Appointment.dart';
import 'package:vetadminconnectmobile/Model/Enums.dart';
import 'package:vetadminconnectmobile/Model/Review.dart';
import 'package:vetadminconnectmobile/Model/User.dart';
import 'package:vetadminconnectmobile/Model/VetSpeciality.dart';

class Vet extends User {
  late int _vetId;
  late List<VetSpeciality> _vetSpecialities;
  late List<Review> _vetReviews;
  late double _averageRating;

  List<VetSpeciality> get vetSpecialities => _vetSpecialities;
  List<Review> get vetReviews => _vetReviews;
  double get averageRating => _averageRating;

  set vetSpecialities(List<VetSpeciality> value) {
    _vetSpecialities = value;
  }
  set vetReviews(List<Review> value) {
    _vetReviews = value;
  }
  set averageRating(double value) {
    _averageRating = value;
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
      super.cityName,
      super.userName,
      super.email,
      super.password,
      super.passwordConfirm,
      super.phoneNumber,
      int vetId,
      List<VetSpeciality> vetSpecialitiesList,
      List<Review> vetReviews,
      double averageRating,
      ) :
        _vetId = vetId ,
        _vetSpecialities = vetSpecialitiesList,
        _vetReviews = vetReviews,
        _averageRating = averageRating;


  factory Vet.fromJson(Map<String, dynamic> json) {
    var vetSpecialitiesJsonList = json['vetSpecialities'] as List<dynamic> ?? [];
    List<VetSpeciality> vetSpecialities = vetSpecialitiesJsonList
        .map((vetSpecialityJson) => VetSpeciality.fromJson(vetSpecialityJson))
        .toList();

    var reviewsJsonList = json['reviews'] as List<dynamic> ?? [];
    List<Review> vetReviews = reviewsJsonList
        .map((reviewJson) => Review.fromJson(reviewJson))
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
      json['cityName'],
      json['userName'],
      json['email'],
      json['password'],
      json['passwordConfirm'],
      json['phoneNumber'],
      json['vetId'],
      vetSpecialities ?? [],
      vetReviews ?? [],
      json['averageRating'].toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> vetSpecialitiesJsonList = _vetSpecialities
        .map((vetSpeciality) => vetSpeciality.toJson())
        .toList();

    List<Map<String, dynamic>> reviewsJsonList = _vetReviews
        .map((review) => review.toJson())
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
      'reviews': reviewsJsonList,
      'averageRating': _averageRating,
    };
  }
}
