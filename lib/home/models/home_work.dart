import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

final class HomeWork extends Equatable {
  const HomeWork({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
    required this.ownerName,
    this.distance = const Option.none(),
    this.description = const Option.none(),
  });

  final String id;
  final DateTime createdAt;
  final String title;
  final String address;
  final double lat;
  final double lng;
  final String ownerName;
  final Option<double> distance;
  final Option<String> description;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        title,
        address,
        lat,
        lng,
        ownerName,
        distance,
        description,
      ];
}
