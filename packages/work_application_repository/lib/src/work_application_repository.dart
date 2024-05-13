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
