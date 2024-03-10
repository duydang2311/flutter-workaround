import 'package:authentication_repository/authentication_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  TaskEither<AuthenticationError, void> signInWithGoogle({
    String? nonce,
    String? captchaToken,
  }) {
    return TaskEither<AuthenticationError, GoogleSignInAuthentication>.tryCatch(
      () async {
        const webClientId =
            '925364545663-2ufqljsno5d4p7e3vuqdn409gdvigcn0.apps.googleusercontent.com';
        const iosClientId =
            '925364545663-ki3uic5n6g2no61m2e3a4sbd01vh9p95.apps.googleusercontent.com';
        final googleSignIn = GoogleSignIn(
          clientId: iosClientId,
          serverClientId: webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        return googleUser!.authentication;
      },
      (error, stackTrace) {
        print(error);
        return const AuthenticationError.unknown();
      },
    ).flatMap<GoogleSignInAuthentication>((googleAuth) {
      if (googleAuth.accessToken == null) {
        return TaskEither.left(
          const AuthenticationError(
            statusCode: 0,
            message: 'No access token found.',
          ),
        );
      }
      if (googleAuth.idToken == null) {
        return TaskEither.left(
          const AuthenticationError(
            statusCode: 0,
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
