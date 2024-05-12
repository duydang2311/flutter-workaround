import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

final class Work extends Equatable {
  const Work({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.ownerName,
    required this.address,
    this.distance = const Option.none(),
    this.description = const Option.none(),
  });

  final String id;
  final DateTime createdAt;
  final String ownerName;
  final String title;
  final String address;
  final Option<double> distance;
  final Option<String> description;

  @override
  List<Object> get props => [
        id,
        createdAt,
        ownerName,
        title,
        address,
        distance,
        description,
      ];
}
