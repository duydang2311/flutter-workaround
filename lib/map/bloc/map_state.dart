part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    this.mapWorks = const {},
    this.error = const Option.none(),
    this.positionStream = const Stream.empty(),
    this.status = MapStatus.none,
  });

  final Map<String, MapWork> mapWorks;
  final Option<UiError> error;
  final Stream<Position> positionStream;
  final MapStatus status;

  MapState copyWith({
    Map<String, MapWork>? mapWorks,
    Option<UiError>? error,
    Stream<Position>? positionStream,
    MapStatus? status,
  }) =>
      MapState(
        mapWorks: mapWorks ?? this.mapWorks,
        error: error ?? this.error,
        positionStream: positionStream ?? this.positionStream,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [mapWorks, error, positionStream, status];
}
