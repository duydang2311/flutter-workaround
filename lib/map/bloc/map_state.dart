part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    this.controller,
    this.markers = const {},
  });

  final GoogleMapController? controller;
  final Set<Marker> markers;

  MapState copyWith({
    GoogleMapController? controller,
    Set<Marker>? markers,
  }) =>
      MapState(
        controller: controller ?? this.controller,
        markers: markers ?? this.markers,
      );

  @override
  List<Object?> get props => [controller, markers];
}
