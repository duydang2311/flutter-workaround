import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:workaround/map/models/popup_status.dart';

final class MapWork extends Equatable {
  const MapWork({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.ownerName,
    required this.lat,
    required this.lng,
    required this.address,
    required this.distance,
    this.popupStatus = PopupStatus.none,
    this.description = const Option.none(),
  });

  final String id;
  final DateTime createdAt;
  final String ownerName;
  final String title;
  final double lat;
  final double lng;
  final String address;
  final double distance;
  final PopupStatus popupStatus;
  final Option<String> description;

  MapWork copyWith({
    String? id,
    DateTime? createdAt,
    String? ownerName,
    String? title,
    double? lat,
    double? lng,
    String? address,
    double? distance,
    PopupStatus? popupStatus,
    Option<String>? description,
  }) =>
      MapWork(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        ownerName: ownerName ?? this.ownerName,
        title: title ?? this.title,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        address: address ?? this.address,
        distance: distance ?? this.distance,
        popupStatus: popupStatus ?? this.popupStatus,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        ownerName,
        title,
        lat,
        lng,
        address,
        distance,
        popupStatus,
        description,
      ];
}
