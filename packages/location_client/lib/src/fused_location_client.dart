import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_client/location_client.dart';
import 'package:shared_kernel/shared_kernel.dart';

final class FusedLocationClient implements LocationClient {
  @override
  Stream<Position> getPositionStream({
    LocationSettings? settings,
  }) =>
      Geolocator.getPositionStream(locationSettings: settings);

  @override
  Task<bool> isLocationServiceEnabled() {
    return const Task(
      Geolocator.isLocationServiceEnabled,
    );
  }

  @override
  Task<LocationPermission> checkPermission() {
    return const Task(Geolocator.checkPermission);
  }

  @override
  TaskEither<GenericError, LocationPermission> requestPermission() {
    return TaskEither.tryCatch(
      Geolocator.requestPermission,
      (error, _) => switch (error) {
        final PermissionDefinitionsNotFoundException e => GenericError(
            message: e.message ?? e.toString(),
            code: 'permission_definitions_not_found',
          ),
        final PermissionRequestInProgressException e => GenericError(
            message: e.message ?? e.toString(),
            code: 'request_in_progress',
          ),
        final Exception e => GenericError.fromException(e),
        _ => const GenericError.unknown(),
      },
    );
  }

  @override
  TaskEither<GenericError, Position> getCurrentPosition({
    bool requestPermission = false,
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) {
    return TaskEither.tryCatch(
      () => Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      ),
      (error, _) => switch (error) {
        final TimeoutException e =>
          GenericError.fromException(e, code: 'timeout'),
        final LocationServiceDisabledException e =>
          GenericError.fromException(e, code: 'disabled'),
        final Exception e => GenericError.fromException(e),
        _ => const GenericError.unknown(),
      },
    );
  }
}
