part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapCreated extends MapEvent {
  const MapCreated({required this.controller});

  final GoogleMapController controller;
}
