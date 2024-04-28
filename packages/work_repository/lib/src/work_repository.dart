import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/src/models/nearby_work.dart';
import 'package:work_repository/work_repository.dart';

abstract interface class WorkRepository {
  Stream<PostgresChangePayload> get stream;
  TaskEither<SaveWorkError, void> insertWork(Work work);
  TaskEither<GenericError, List<NearbyWork>> getNearbyWorks(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
  });
}
