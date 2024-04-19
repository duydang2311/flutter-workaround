part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    required this.controller,
  });

  final GoogleMapController? controller;

  MapState copyWith({
    GoogleMapController? controller,
  }) =>
      MapState(
        controller: controller ?? this.controller,
      );

  @override
  List<Object?> get props => [controller];
}
