import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';

abstract interface class WorkRepository {
  Stream<PostgresChangePayload> get stream;
  TaskEither<SaveWorkError, void> insertWork(Work work);
  TaskEither<GenericError, Map<String, dynamic>> getWorkById(
    String id, {
    String columns = '*',
  });
  TaskEither<GenericError, List<NearbyWork>> getNearbyWorks(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
  });
  TaskEither<GenericError, List<NearbyWorkWithDescription>>
      getNearbyWorksWithDescription(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
    int descriptionLength = 80,
  });
  TaskEither<GenericError, List<Map<String, dynamic>>> getWorks({
    String? from,
    String columns = '*',
    ColumnOrder? order,
    int? limit,
  });
}
