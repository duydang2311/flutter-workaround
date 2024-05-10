import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/dart_define.gen.dart';
import 'package:workaround/map/map.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required WorkRepository workRepository,
    required LocationClient locationClient,
    required Client client,
  })  : _workRepository = workRepository,
        _locationClient = locationClient,
        _client = client,
        super(const MapState()) {
    on<MapInitialized>(_handleMapInitialized);
    on<MapChanged>(_handleMapChanged);
    on<MapWorkTapped>(_handleWorkTapped);
    on<_MapStatusChanged>(_handleStatusChanged);
    on<_MapWorksChanged>(_handleWorksChanged);
    on<_MapAddressChanged>(_handleAddressChanged);
  }

  final WorkRepository _workRepository;
  final LocationClient _locationClient;
  final Client _client;
  late final StreamSubscription<PostgresChangePayload> _streamSubscription;
  late final StreamSubscription<Position>? _positionStreamSubscription;
  Position? _lastPosition;
  double _distance = 0;
  static const double _distanceThreshold = 100;

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    await _positionStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> _handleMapInitialized(
    MapInitialized event,
    Emitter<MapState> emit,
  ) async {
    _streamSubscription = _workRepository.stream.listen(_handleWorkChanged);

    emit(state.copyWith(status: MapStatus.pending));
    await _locationClient
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
        .match((l) {
      emit(
        state.copyWith(
          error: Option.of(
            UiError.now(
              message: l.formatted,
            ),
          ),
        ),
      );
    }, (r) {
      final positionStream = _locationClient.getPositionStream(
        settings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      _positionStreamSubscription = positionStream.listen(
        _handleCurrentPosition,
        onError: (dynamic error, stackTrace) {
          emit(
            state.copyWith(
              error: Option.of(
                UiError.now(
                  message: switch (error) {
                    final Exception e => GenericError.fromException(e),
                    _ => const GenericError.unknown(),
                  }
                      .formatted,
                ),
              ),
            ),
          );
        },
      );
      emit(state.copyWith(positionStream: positionStream));
    }).run();

    final mapWorks = await _nearbyMapWorksTask.run();
    emit(
      state.copyWith(
        mapWorks: {
          for (final e in mapWorks)
            e.id: e.copyWith(description: state.mapWorks[e.id]?.description),
        },
        status: MapStatus.none,
      ),
    );
  }

  Future<void> _handleMapChanged(
    MapChanged event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.pending));
    final mapWorks = await _nearbyMapWorksTask.run();
    emit(
      state.copyWith(
        mapWorks: {
          for (final e in mapWorks)
            e.id: e.copyWith(description: state.mapWorks[e.id]?.description),
        },
        status: MapStatus.none,
      ),
    );
  }

  void _handleWorkChanged(PostgresChangePayload payload) {
    add(const MapChanged());
  }

  Future<void> _handleWorkTapped(
    MapWorkTapped event,
    Emitter<MapState> emit,
  ) async {
    final work = state.mapWorks[event.id];
    if (work == null) return;
    emit(
      state.copyWith(
        mapWorks: {
          ...state.mapWorks,
          event.id: work.copyWith(
            popupStatus: PopupStatus.pending,
          ),
        },
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
      final work = state.mapWorks[event.id];
      emit(
        state.copyWith(
          mapWorks: {
            ...state.mapWorks,
            if (work != null)
              event.id: work.copyWith(
                description: Option.fromNullable(r.description),
                popupStatus: PopupStatus.none,
              ),
          },
          error: const Option.none(),
        ),
      );
    }).run();
  }

  void _handleStatusChanged(_MapStatusChanged event, Emitter<MapState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _handleWorksChanged(_MapWorksChanged event, Emitter<MapState> emit) {
    emit(state.copyWith(mapWorks: event.mapWorks));
  }

  void _handleAddressChanged(_MapAddressChanged event, Emitter<MapState> emit) {
    emit(state.copyWith(address: event.address));
  }

  Future<void> _handleCurrentPosition(Position position) async {
    if (_lastPosition != null) {
      _distance += Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (_distance < _distanceThreshold) return;
      _distance -= _distanceThreshold;
    }
    _lastPosition = position;
    add(const _MapStatusChanged(status: MapStatus.pending));
    final (works, address) = await (
      _workRepository
          .getNearbyWorks(position.latitude, position.longitude)
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
          .getOrElse((l) => const [])
          .run(),
      TaskEither.tryCatch(
        () => _client.get(
          Uri.https(
            'rsapi.goong.io',
            '/Geocode',
            {
              'latlng': '${position.latitude}, ${position.longitude}',
              'api_key': DartDefine.goongApiKey,
            },
          ),
        ),
        (error, _) => switch (error) {
          final Exception e => GenericError.fromException(e),
          _ => const GenericError.unknown(),
        },
      )
          .map(
            (response) => jsonDecode(utf8.decode(response.bodyBytes))
                as Map<String, dynamic>,
          )
          .flatMap(
            (json) => TaskEither.fromNullable(
              (json['results'] as List?)?.first as Map<String, dynamic>?,
              () => const GenericError(
                message: 'Could not convert JSON.',
              ),
            ),
          )
          .map(Place.fromJson)
          .match((l) => 'Unknown location', (r) => r.address)
          .run(),
    ).wait;
    add(_MapWorksChanged(
      mapWorks: {
        for (final e in works)
          e.id: e.copyWith(description: state.mapWorks[e.id]?.description),
      },
    ));
    add(_MapAddressChanged(address: address));
    add(const _MapStatusChanged(status: MapStatus.none));
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

  TaskEither<GenericError, Stream<Position>> _getPositionStreamWithRetry({
    LocationSettings? settings,
    bool retry = true,
  }) =>
      TaskEither.tryCatch(
        () async {
          // log('${await _locationClient.checkPermission().run()}');
          final stream = _locationClient.getPositionStream(settings: settings);
          await stream.listen((data) {
            log('_data: $data');
          }).cancel();
          return _locationClient.getPositionStream(settings: settings);
        },
        (error, _) => switch (error) {
          final TimeoutException e =>
            GenericError.fromException(e, code: 'timeout'),
          final LocationServiceDisabledException e =>
            GenericError.fromException(e, code: 'disabled'),
          final Exception e => GenericError.fromException(e),
          _ => const GenericError.unknown(),
        },
      ).orElse(
        (l) {
          log('_orElse $l');
          return switch (retry) {
            true => _toTaskEitherStreamPosition(l, settings: settings),
            false => TaskEither.left(l),
          };
        },
      );

  TaskEither<GenericError, Stream<Position>> _toTaskEitherStreamPosition(
    GenericError error, {
    LocationSettings? settings,
  }) {
    return switch (error.code) {
      'disabled' =>
        _locationClient.checkPermission().toTaskEither<GenericError>(),
      _ => TaskEither<GenericError, LocationPermission>.left(
          const GenericError.unknown(),
        ),
    }
        .flatMap(
          (r) {
            log('_permission: $r');
            return switch (r) {
              LocationPermission.denied => _locationClient.requestPermission(),
              _ => TaskEither.right(r),
            };
          },
        )
        .flatMap(
          (r) => switch (r) {
            LocationPermission.always ||
            LocationPermission.whileInUse =>
              TaskEither.right(r),
            _ => TaskEither<GenericError, LocationPermission>.left(
                const GenericError.unknown(),
              ),
          },
        )
        .flatMap(
          (r) => _getPositionStreamWithRetry(settings: settings, retry: false),
        );
  }
}
