import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseAuthenticationRepository
    implements AuthenticationRepository {
  const SupabaseAuthenticationRepository({
    required Supabase supabase,
    required String supabaseRedirectUrl,
  })  : _supabase = supabase,
        _supabaseRedirectUrl = supabaseRedirectUrl;

  final Supabase _supabase;
  final String _supabaseRedirectUrl;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabase.client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: _supabaseRedirectUrl,
    );
  }

  @override
  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }
}
