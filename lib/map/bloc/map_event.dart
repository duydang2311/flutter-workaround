part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapInitialized extends MapEvent {
  const MapInitialized();
}

final class MapChanged extends MapEvent {
  const MapChanged();
}

final class MapWorkTapped extends MapEvent {
  const MapWorkTapped(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class _MapWorksChanged extends MapEvent {
  const _MapWorksChanged({required this.mapWorks});

  final Map<String, MapWork> mapWorks;

  @override
  List<Object> get props => [mapWorks];
}

final class _MapStatusChanged extends MapEvent {
  const _MapStatusChanged({required this.status});

  final MapStatus status;

  @override
  List<Object> get props => [status];
}

final class _MapAddressChanged extends MapEvent {
  const _MapAddressChanged({required this.address});

  final String address;

  @override
  List<Object> get props => [address];
}
