import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/src/models/get_user_error.dart';
import 'package:user_repository/user_repository.dart';

final class SupabaseAppUserRepository implements AppUserRepository {
  const SupabaseAppUserRepository({required Supabase supabase})
      : _supabase = supabase;

  final Supabase _supabase;

  @override
  Option<AppUser> get currentUser =>
      Option.fromNullable(_supabase.client.auth.currentSession)
          .map((session) => AppUser(session.user.id));

  @override
  Stream<Option<AppUser>> get currentUserStream =>
      _supabase.client.auth.onAuthStateChange.map((state) {
        if (state.session != null) _supabase.client.auth.signOut();
        return Option.fromNullable(state.session).map(
          (t) => AppUser(t.user.id),
        );
      });

  @override
  TaskEither<GetUserError, AppUser> getUser() {
    return TaskEither.tryCatch(
      _supabase.client.auth.getUser,
      (exception, stackTrace) {
        if (exception is AuthException) {
          return GetUserError.fromException(exception);
        }
        return const GetUserError.unknown();
      },
    )
        .flatMap(
          (response) => Either.fromNullable(response.user, GetUserError.unknown)
              .toTaskEither(),
        )
        .map((user) => AppUser(user.id));
  }
}
