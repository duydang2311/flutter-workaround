import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_application_repository/work_application_repository.dart';

final class SupabaseWorkApplicationRepository
    implements WorkApplicationRepository {
  const SupabaseWorkApplicationRepository({required SupabaseClient client})
      : _client = client;

  final SupabaseClient _client;

  @override
  TaskEither<GenericError, dynamic> insert(
    WorkApplication application, {
    String? columns,
  }) {
    PostgrestTransformBuilder<dynamic> builder =
        _client.from('work_applications').insert({
      'work_id': application.workId,
      'applicant_id': application.applicantId,
    });
    if (columns != null) {
      builder = builder.select(columns).maybeSingle();
    }
    return TaskEither.tryCatch(
      () => builder,
      _catch,
    );
  }

  @override
  TaskEither<GenericError, bool> exists({
    String? id,
    String? workId,
    String? applicantId,
  }) {
    return TaskEither.tryCatch(
      () => _client.from('work_applications').count().match({
        if (id != null) 'id': id,
        if (workId != null) 'work_id': workId,
        if (applicantId != null) 'applicant_id': applicantId,
      }),
      _catch,
    ).map((r) => r > 0);
  }

  @override
  TaskEither<GenericError, Map<String, dynamic>> getOne({
    String? id,
    String? workId,
    String? applicantId,
    int? limit,
    String columns = '*',
  }) {
    PostgrestTransformBuilder<PostgrestList> builder =
        _client.from('work_applications').select(columns).match({
      if (id != null) 'id': id,
      if (workId != null) 'work_id': workId,
      if (applicantId != null) 'applicant_id': applicantId,
    });
    if (limit != null) {
      builder = builder.limit(1);
    }
    return TaskEither.tryCatch(
      () => builder.maybeSingle(),
      _catch,
    ).flatMap(
      (r) => TaskEither.fromNullable(
        r,
        () => const GenericError(
          message: 'Unable to find work application.',
          code: 'not_found',
        ),
      ),
    );
  }

  @override
  TaskEither<GenericError, int> countByWorkId(
    String id, {
    String columns = '*',
  }) {
    return TaskEither.tryCatch(
      () => _client.from('work_applications').count().eq('work_id', id),
      _catch,
    );
  }

  @override
  TaskEither<GenericError, dynamic> delete({
    String? id,
    String? workId,
    String? applicantId,
  }) {
    return TaskEither.tryCatch(
      () => _client.from('work_applications').delete().match({
        if (id != null) 'id': id,
        if (workId != null) 'work_id': workId,
        if (applicantId != null) 'applicant_id': applicantId,
      }),
      _catch,
    );
  }

  GenericError _catch(Object error, StackTrace stackTrace) => switch (error) {
        final PostgrestException e => GenericError.fromPostgrestException(e),
        final Exception e => GenericError.fromException(e),
        _ => const GenericError.unknown(),
      };
}
