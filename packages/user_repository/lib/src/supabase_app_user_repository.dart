import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

final class SupabaseAppUserRepository implements AppUserRepository {
  const SupabaseAppUserRepository({required Supabase supabase})
      : _supabase = supabase;

  final Supabase _supabase;

  @override
  Stream<Option<AppUser>> get user =>
      _supabase.client.auth.onAuthStateChange.map((state) {
        // if (state.session != null) _supabase.client.auth.signOut();
        return state.session == null
            ? const Option.none()
            : Some(AppUser(state.session!.user.id));
      });

  @override
  TaskOption<AppUser> getUser() {
    return TaskOption(() async {
      if (_supabase.client.auth.currentSession == null) {
        return const Option.none();
      }

      final response = await _supabase.client.auth.getUser();
      return response.user == null
          ? const Option.none()
          : Some(AppUser(response.user!.id));
    });
  }
}
