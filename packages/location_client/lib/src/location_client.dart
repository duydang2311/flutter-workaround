import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_kernel/shared_kernel.dart';

abstract interface class LocationClient {
  Task<bool> isLocationServiceEnabled();
  Task<LocationPermission> checkPermission();
  TaskEither<GenericError, LocationPermission> requestPermission();
  TaskEither<GenericError, Position> getCurrentPosition({
    bool requestPermission = false,
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  });
  Either<GenericError, Stream<Position>> getPositionStream({
    LocationSettings? settings,
  });
}
