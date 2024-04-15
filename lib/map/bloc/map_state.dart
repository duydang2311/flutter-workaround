part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    required this.controller,
    required this.initialCameraPosition,
  });

  final GoogleMapController? controller;
  final CameraPosition initialCameraPosition;

  MapState copyWith({
    GoogleMapController? controller,
    CameraPosition? initialCameraPosition,
  }) =>
      MapState(
        controller: controller ?? this.controller,
        initialCameraPosition:
            initialCameraPosition ?? this.initialCameraPosition,
      );

  @override
  List<Object?> get props => [controller, initialCameraPosition];
}
