import 'package:equatable/equatable.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart';
import 'package:workaround/map/models/popup_status.dart';

final class MapWork extends Equatable {
  const MapWork({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.distance,
    this.popupStatus = PopupStatus.none,
    this.description = const Option.none(),
  });

  final String id;
  final String title;
  final double lat;
  final double lng;
  final double distance;
  final PopupStatus popupStatus;
  final Option<String> description;

  MapWork copyWith({
    String? id,
    String? title,
    double? lat,
    double? lng,
    double? distance,
    PopupStatus? popupStatus,
    Option<String>? description,
  }) =>
      MapWork(
        id: id ?? this.id,
        title: title ?? this.title,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        distance: distance ?? this.distance,
        popupStatus: popupStatus ?? this.popupStatus,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        lat,
        lng,
        distance,
        popupStatus,
        description,
      ];
}
