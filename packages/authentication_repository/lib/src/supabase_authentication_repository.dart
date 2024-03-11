import 'package:authentication_repository/authentication_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseAuthenticationRepository
    implements AuthenticationRepository {
  const SupabaseAuthenticationRepository({
    required Supabase supabase,
    required String supabaseRedirectUrl,
    required String webClientId,
    required String iosClientId,
  })  : _supabase = supabase,
        _supabaseRedirectUrl = supabaseRedirectUrl,
        _webClientId = webClientId,
        _iosClientId = iosClientId;

  final Supabase _supabase;
  final String _supabaseRedirectUrl;
  final String _webClientId;
  final String _iosClientId;

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
  TaskEither<AuthenticationError, void> signInWithGoogle({
    String? nonce,
    String? captchaToken,
  }) {
    return TaskEither<AuthenticationError, GoogleSignInAuthentication>.tryCatch(
      () async {
        final googleSignIn = GoogleSignIn(
          clientId: _iosClientId,
          serverClientId: _webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        return googleUser!.authentication;
      },
      (error, stackTrace) {
        return const AuthenticationError.unknown();
      },
    ).flatMap<GoogleSignInAuthentication>((googleAuth) {
      if (googleAuth.accessToken == null) {
        return TaskEither.left(
          const AuthenticationError(
            code: 'access_token_not_found',
            message: 'No access token found.',
          ),
        );
      }
      if (googleAuth.idToken == null) {
        return TaskEither.left(
          const AuthenticationError(
            code: 'id_token_not_found',
            message: 'No ID token found.',
          ),
        );
      }
      return TaskEither.right(googleAuth);
    }).flatMap(
      (googleAuth) => TaskEither.tryCatch(
        () async {
          await _supabase.client.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: googleAuth.idToken!,
            accessToken: googleAuth.accessToken,
            nonce: nonce,
            captchaToken: captchaToken,
          );
        },
        _catch,
      ),
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
      return AuthenticationError.fromException(error);
    }
    return const AuthenticationError.unknown();
  }
}
