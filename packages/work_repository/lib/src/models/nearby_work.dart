import 'package:equatable/equatable.dart';
import 'package:work_repository/work_repository.dart';

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
    required this.status,
  });

  final String id;
  final DateTime createdAt;
  final String ownerName;
  final String title;
  final String address;
  final double lat;
  final double lng;
  final double distance;
  final WorkStatus status;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        ownerName,
        title,
        address,
        lat,
        lng,
        distance,
        status,
      ];
}
