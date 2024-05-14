import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:work_repository/work_repository.dart';

final class HomeWork extends Equatable {
  const HomeWork({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
    required this.ownerName,
    required this.status,
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
  final WorkStatus status;
  final Option<double> distance;
  final Option<String> description;

  HomeWork copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? address,
    double? lat,
    double? lng,
    String? ownerName,
    WorkStatus? status,
    Option<double>? distance,
    Option<String>? description,
  }) =>
      HomeWork(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        title: title ?? this.title,
        address: address ?? this.address,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        ownerName: ownerName ?? this.ownerName,
        status: status ?? this.status,
        distance: distance ?? this.distance,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        title,
        address,
        lat,
        lng,
        ownerName,
        status,
        distance,
        description,
      ];
}
