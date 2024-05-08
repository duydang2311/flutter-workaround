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
