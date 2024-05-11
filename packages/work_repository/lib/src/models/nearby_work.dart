import 'package:equatable/equatable.dart';

class NearbyWork extends Equatable {
  const NearbyWork({
    required this.id,
    required this.createdAt,
    required this.ownerName,
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
    required this.distance,
  });

  final String id;
  final DateTime createdAt;
  final String ownerName;
  final String title;
  final String address;
  final double lat;
  final double lng;
  final double distance;

  @override
  List<Object?> get props =>
      [id, createdAt, ownerName, title, address, lat, lng, distance];
}
