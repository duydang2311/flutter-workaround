import 'package:equatable/equatable.dart';

final class Work extends Equatable {
  Work({
    this.id = '',
    this.ownerId = '',
    this.placeId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lat = 0,
    this.lng = 0,
    this.title = '',
    this.description,
  })  : createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String placeId;
  final double lat;
  final double lng;
  final String title;
  final String? description;

  @override
  List<Object?> get props => [
        id,
        ownerId,
        createdAt,
        updatedAt,
        placeId,
        lat,
        lng,
        title,
        description,
      ];
}
