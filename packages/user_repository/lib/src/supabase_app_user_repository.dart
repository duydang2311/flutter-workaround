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
        return state.session == null
            ? const Option.none()
            : Some(AppUser(state.session!.user.id));
      });
}
