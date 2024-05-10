part of 'map_bloc.dart';

final class MapState extends Equatable {
  const MapState({
    this.mapWorks = const {},
    this.error = const Option.none(),
    this.positionStream = const Stream.empty(),
    this.status = MapStatus.none,
    this.address = '',
  });

  final Map<String, MapWork> mapWorks;
  final Option<UiError> error;
  final Stream<Position> positionStream;
  final MapStatus status;
  final String address;

  MapState copyWith({
    Map<String, MapWork>? mapWorks,
    Option<UiError>? error,
    Stream<Position>? positionStream,
    MapStatus? status,
    String? address,
  }) =>
      MapState(
        mapWorks: mapWorks ?? this.mapWorks,
        error: error ?? this.error,
        positionStream: positionStream ?? this.positionStream,
        status: status ?? this.status,
        address: address ?? this.address,
      );

  @override
  List<Object?> get props => [
        mapWorks,
        error,
        positionStream,
        status,
        address,
      ];
}
