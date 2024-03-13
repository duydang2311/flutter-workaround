import 'package:equatable/equatable.dart';

final class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.displayName,
    required this.imageUrl,
  });

  factory Profile.from(dynamic data) {
    print(data['created_at']);
    print(data['updated_at']);
    return Profile(
      id: (data['id'] ?? '') as String,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      userName: (data['user_name'] ?? '') as String,
      displayName: (data['display_name'] ?? '') as String,
      imageUrl: (data['image_url'] ?? '') as String,
    );
  }

  static Profile? tryParse(Map<String, dynamic> data) {
    final id = data['id'] as String;
    if (id.isEmpty) return null;

    return Profile(
      id: id,
      createdAt: _tryParseDateTime(data['created_at']),
      updatedAt: _tryParseDateTime(data['updated_at']),
      userName: (data['user_name'] ?? '') as String,
      displayName: (data['display_name'] ?? '') as String,
      imageUrl: (data['image_url'] ?? '') as String,
    );
  }

  static DateTime _tryParseDateTime(dynamic input) {
    final inputString = input as String?;
    if (inputString == null) return DateTime.now();
    return DateTime.tryParse(inputString) ?? DateTime.now();
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userName;
  final String displayName;
  final String imageUrl;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        userName,
        displayName,
        imageUrl,
      ];
}
