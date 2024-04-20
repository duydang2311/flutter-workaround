import 'package:equatable/equatable.dart';

final class Work extends Equatable {
  Work({
    this.id = '',
    this.ownerId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lat = 0,
    this.lng = 0,
    this.title = '',
    this.description,
  })  : createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

  factory Work.fromMap(Map<String, Object?> map) {
    return Work(
      id: (map['id'] ?? '') as String,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at']! as String),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at']! as String),
      ownerId: (map['owner_id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
    );
  }

  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double lat;
  final double lng;
  final String title;
  final String? description;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'owner_id': ownerId,
      'title': title,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, title, description];
}
