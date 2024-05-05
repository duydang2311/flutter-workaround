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

  factory Work.fromJson(Map<String, dynamic> json) {
    final createdAt = json['created_at'] as String?;
    final updatedAt = json['updated_at'] as String?;
    return Work(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt),
      updatedAt: updatedAt == null ? null : DateTime.tryParse(updatedAt),
      placeId: json['place_id'] as String? ?? '',
      lat: json['lat'] as double? ?? 0,
      lng: json['lng'] as double? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

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
