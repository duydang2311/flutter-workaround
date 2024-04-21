import 'package:fpdart/fpdart.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:work_repository/src/models/nearby_work.dart';
import 'package:work_repository/work_repository.dart';

abstract interface class WorkRepository {
  TaskEither<SaveWorkError, void> insertWork(Work work);
  TaskEither<GenericError, List<NearbyWork>> getNearbyWorks(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
  });
}
