import 'package:vetadminconnectmobile/Model/Client.dart';
import 'package:vetadminconnectmobile/Model/Vet.dart';

class Review {
  final int id;
  final int clientId;
  final Client? client;
  final int vetId;
  final Vet? vet;
  final double rating;
  final String comment;

  Review({
    required this.id,
    required this.clientId,
    this.client,
    required this.vetId,
    this.vet,
    required this.rating,
    required this.comment,
  });

  // fromJson
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      clientId: json['clientId'] as int,
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      vetId: json['vetId'] as int,
      vet: json['vet'] != null ? Vet.fromJson(json['vet']) : null,
      rating: json['rating'].toDouble(),
      comment: json['comment'] as String,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'client': client?.toJson(),
      'vetId': vetId,
      'vet': vet?.toJson(),
      'rating': rating,
      'comment': comment,
    };
  }
}
