import 'package:fpdart/fpdart.dart';
import 'package:work_repository/work_repository.dart';

abstract interface class WorkRepository {
  TaskEither<SaveWorkError, void> insertWork(Work work);
}
