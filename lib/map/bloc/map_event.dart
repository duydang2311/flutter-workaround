part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapInitialized extends MapEvent {
  const MapInitialized();
}

final class MapCreated extends MapEvent {
  const MapCreated({required this.controller});

  final GoogleMapController controller;
}
