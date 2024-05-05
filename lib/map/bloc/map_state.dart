part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    this.mapWorks = const [],
    this.error = const Option.none(),
  });

  final List<MapWork> mapWorks;
  final Option<UiError> error;

  MapState copyWith({
    List<MapWork>? mapWorks,
    Option<UiError>? error,
  }) =>
      MapState(
        mapWorks: mapWorks ?? this.mapWorks,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [mapWorks, error];
}
