import 'package:equatable/equatable.dart';

final class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.displayName,
    required this.imageUrl,
    this.dob,
    this.gender,
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
      dob: _tryParseDateTimeDob(data['dob']),
      gender: (data['gender'] ?? '') as String,
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
      dob: _tryParseDateTimeDob(data['dob']),
      gender: (data['gender'] ?? '') as String,
    );
  }

  static DateTime _tryParseDateTime(dynamic input) {
    final inputString = input as String?;
    if (inputString == null) return DateTime.now();
    return DateTime.tryParse(inputString) ?? DateTime.now();
  }

static DateTime? _tryParseDateTimeDob(dynamic input) {
    if (input == null) return null; 
    if (input is DateTime) return input; 

    final inputString = input as String?;
    if (inputString == null) return null; 

    try {
      return DateTime.parse(inputString); 
    } catch (e) {
      print('Failed to parse date: $e');
      return null; 
    }
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userName;
  final String displayName;
  final String imageUrl;
  final DateTime? dob;
  final String? gender;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        userName,
        displayName,
        imageUrl,
        dob,
      ];
}
