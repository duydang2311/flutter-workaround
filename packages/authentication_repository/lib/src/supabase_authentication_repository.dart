import 'package:authentication_repository/authentication_repository.dart';
import 'package:fpdart/fpdart.dart';
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
  TaskEither<AuthenticationError, void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _supabase.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      },
      _catch,
    );
  }

  @override
  TaskEither<AuthenticationError, void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        await _supabase.client.auth.signUp(
          email: email,
          password: password,
          emailRedirectTo: _supabaseRedirectUrl,
        );
      },
      _catch,
    );
  }

  @override
  TaskEither<AuthenticationError, void> signOut() {
    return TaskEither.tryCatch(
      () async {
        await _supabase.client.auth.signOut();
      },
      _catch,
    );
  }

  AuthenticationError _catch(Object error, StackTrace stackTrace) {
    if (error is AuthException) {
      return AuthenticationError(
        statusCode:
            error.statusCode == null ? 0 : int.tryParse(error.statusCode!) ?? 0,
        message: error.message,
      );
    }
    return const AuthenticationError(statusCode: 0, message: 'Unknown error');
  }
}
