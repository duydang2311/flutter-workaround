import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/map/map.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required WorkRepository workRepository,
    required LocationClient locationClient,
  })  : _workRepository = workRepository,
        _locationClient = locationClient,
        super(const MapState()) {
    on<MapInitialized>(_handleMapInitialized);
    on<MapChanged>(_handleMapChanged);
    on<MapWorkTapped>(_handleWorkTapped);
    _streamSubscription = _workRepository.stream.listen(_handleWorkChanged);
  }

  final WorkRepository _workRepository;
  final LocationClient _locationClient;
  late final StreamSubscription<PostgresChangePayload> _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }

  Future<void> _handleMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        positionStream: _locationClient.getPositionStream(
          const LocationSettings(),
        ),
      ),
    );
    final mapWorks = await _nearbyMapWorksTask.run();
    emit(state.copyWith(mapWorks: mapWorks));
  }

  Future<void> _handleMapChanged(
    MapChanged event,
    Emitter<MapState> emit,
  ) async {
    final mapWorks = await _nearbyMapWorksTask.run();
    emit(state.copyWith(mapWorks: mapWorks));
  }

  void _handleWorkChanged(PostgresChangePayload payload) {
    add(const MapChanged());
  }

  Future<void> _handleWorkTapped(
    MapWorkTapped event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        mapWorks: state.mapWorks
            .map(
              (e) => e.id != event.id
                  ? e
                  : e.copyWith(
                      popupStatus: PopupStatus.pending,
                    ),
            )
            .toList(),
      ),
    );
    await _workRepository
        .getWorkById(
      event.id,
      columns: 'owner_id, created_at, title, description',
    )
        .match((l) {
      emit(state.copyWith(error: Option.of(UiError.now(message: l.message))));
    }, (r) {
      emit(
        state.copyWith(
          tappedId: Option.of(event.id),
          mapWorks: state.mapWorks
              .map(
                (e) => e.id != event.id
                    ? e
                    : e.copyWith(
                        description: Option.fromNullable(r.description),
                        popupStatus: PopupStatus.none,
                      ),
              )
              .toList(),
          error: const Option.none(),
        ),
      );
    }).run();
  }

  Task<List<MapWork>> get _nearbyMapWorksTask => _locationClient
      .checkPermission()
      .toTaskEither<GenericError>()
      .flatMap<LocationPermission>(
        (r) => switch (r) {
          LocationPermission.denied => _locationClient.requestPermission(),
          LocationPermission.always ||
          LocationPermission.whileInUse =>
            TaskEither.right(r),
          _ => TaskEither.left(const GenericError.unknown()),
        },
      )
      .flatMap<LocationPermission>(
        (r) => switch (r) {
          LocationPermission.always ||
          LocationPermission.whileInUse =>
            TaskEither.right(r),
          _ => TaskEither.left(const GenericError.unknown()),
        },
      )
      .flatMap((r) => _locationClient.getCurrentPosition())
      .flatMap((r) => _workRepository.getNearbyWorks(r.latitude, r.longitude))
      .map(
        (r) => List<MapWork>.from(
          r.map(
            (e) => MapWork(
              id: e.id,
              title: e.title,
              lat: e.lat,
              lng: e.lng,
              distance: e.distance,
            ),
          ),
        ),
      )
      .getOrElse((l) => const []);
}
