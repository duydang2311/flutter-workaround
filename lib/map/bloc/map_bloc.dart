import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';
import 'package:geolocator/geolocator.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required TextStyle textStyle,
    required Color backgroundColor,
    required WorkRepository workRepository,
    required LocationClient locationClient,
  })  : _textStyle = textStyle,
        _backgroundColor = backgroundColor,
        _workRepository = workRepository,
        _locationClient = locationClient,
        super(const MapState()) {
    on<MapInitialized>(_handleMapInitialized);
    on<MapCreated>(_handleMapCreated);
    on<MapChanged>(_handleMapChanged);
    _streamSubscription = _workRepository.stream.listen(_handleWorkChanged);
  }

  final TextStyle _textStyle;
  final Color _backgroundColor;
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
    final markers = await _nearbyMarkersTask.run();
    emit(state.copyWith(markers: markers));
  }

  Future<void> _handleMapCreated(
    MapCreated event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(controller: event.controller));
  }

  Future<void> _handleMapChanged(
    MapChanged event,
    Emitter<MapState> emit,
  ) async {
    final markers = await _nearbyMarkersTask.run();
    emit(state.copyWith(markers: markers));
  }

  Task<Set<Marker>> get _nearbyMarkersTask => _locationClient
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
      .flatMap(
        (r) => _workRepository.getNearbyWorks(r.latitude, r.longitude),
      )
      .flatMap(
        (r) => TaskEither<GenericError, Set<Marker>>(() async {
          final bitmaps = await r
              .map(
                (e) => createCustomMarkerBitmap(
                  e.title,
                  textStyle: _textStyle,
                  backgroundColor: _backgroundColor,
                ),
              )
              .wait;
          return Either.right(
            Set.from(
              r.zip(bitmaps).map<Marker>((e) {
                final (work, bitmap) = e;
                return Marker(
                  markerId: MarkerId(work.id),
                  icon: bitmap,
                  position: LatLng(work.lat, work.lng),
                );
              }),
            ),
          );
        }),
      )
      .getOrElse((l) => <Marker>{});

  void _handleWorkChanged(PostgresChangePayload payload) {
    add(const MapChanged());
  }
}
