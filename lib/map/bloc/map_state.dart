part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    this.mapWorks = const [],
    this.error = const Option.none(),
    this.positionStream = const Stream.empty(),
    this.tappedId = const Option.none(),
  });

  final List<MapWork> mapWorks;
  final Option<UiError> error;
  final Stream<Position> positionStream;
  final Option<String> tappedId;

  MapState copyWith({
    List<MapWork>? mapWorks,
    Option<UiError>? error,
    Stream<Position>? positionStream,
    Option<String>? tappedId,
  }) =>
      MapState(
        mapWorks: mapWorks ?? this.mapWorks,
        error: error ?? this.error,
        positionStream: positionStream ?? this.positionStream,
        tappedId: tappedId ?? this.tappedId,
      );

  @override
  List<Object?> get props => [mapWorks, error, positionStream, tappedId];
}
