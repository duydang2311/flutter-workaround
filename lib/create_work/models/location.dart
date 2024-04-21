import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

final class Location extends Equatable {
  const Location({
    this.position,
    this.address,
    this.errorMessage,
  });

  final Position? position;
  final String? address;
  final String? errorMessage;

  @override
  List<Object?> get props => [position, address, errorMessage];
}
