import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

final class SupabaseAppUserRepository implements AppUserRepository {
  const SupabaseAppUserRepository({required Supabase supabase})
      : _supabase = supabase;

  final Supabase _supabase;

  @override
  Stream<AppUser?> get user => _supabase.client.auth.onAuthStateChange.map(
        (state) =>
            state.session == null ? null : AppUser(state.session!.user.id),
      );
}
