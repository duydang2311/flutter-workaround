import 'package:equatable/equatable.dart';

final class NearbyWork extends Equatable {
  const NearbyWork({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.distance,
  });

  final String id;
  final String title;
  final double lat;
  final double lng;
  final double distance;

  @override
  List<Object?> get props => [id, title, lat, lng, distance];
}
