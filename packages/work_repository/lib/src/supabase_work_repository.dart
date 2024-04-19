import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';

final class SupabaseWorkRepository implements WorkRepository {
  SupabaseWorkRepository({required Supabase supabase}) : _supabase = supabase;

  final Supabase _supabase;

  @override
  TaskEither<SaveWorkError, void> insertWork(Work work) {
    return TaskEither.tryCatch(
      () => _supabase.client.from('works').insert({
        'owner_id': work.ownerId,
        'title': work.title,
        'description': work.description,
      }),
      _catch,
    );
  }

  SaveWorkError _catch(Object error, StackTrace stackTrace) {
    switch (error) {
      case final AuthException e:
        return SaveWorkError.fromException(e);
      case final Exception e:
        return SaveWorkError.fromException(e);
      default:
        return const SaveWorkError.unknown();
    }
  }
}
