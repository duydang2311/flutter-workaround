import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:work_application_repository/work_application_repository.dart';

abstract interface class WorkApplicationRepository {
  const WorkApplicationRepository();

  TaskEither<GenericError, dynamic> insert(
    WorkApplication application, {
    String? columns,
  });
  TaskEither<GenericError, bool> exists({
    String? id,
    String? workId,
    String? applicantId,
  });
  TaskEither<GenericError, Map<String, dynamic>> getOne({
    String? id,
    String? workId,
    String? applicantId,
    int? limit,
    String columns = '*',
  });
  TaskEither<GenericError, List<Map<String, dynamic>>> getMany({
    String? from,
    String columns = '*',
    String? id,
    String? workId,
    String? applicantId,
    RowRange? range,
    ColumnOrder? order,
    Map<String, Object>? match,
  });
  TaskEither<GenericError, int> countByWorkId(
    String id, {
    String columns = '*',
  });
  TaskEither<GenericError, dynamic> delete({
    String? id,
    String? workId,
    String? applicantId,
  });
}
