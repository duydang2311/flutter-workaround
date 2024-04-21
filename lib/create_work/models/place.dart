import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

final class Place extends Equatable {
  const Place({
    required this.id,
    required this.lat,
    required this.lng,
    required this.address,
    this.errorMessage = const Option.none(),
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final location = geometry['location'] as Map<String, dynamic>;
    return Place(
      id: json['place_id'] as String,
      lat: location['lat'] as double,
      lng: location['lng'] as double,
      address: json['formatted_address'] as String,
    );
  }

  final String id;
  final double lat;
  final double lng;
  final String address;
  final Option<String> errorMessage;

  @override
  List<Object?> get props => [id, lat, lng, address, errorMessage];
}
