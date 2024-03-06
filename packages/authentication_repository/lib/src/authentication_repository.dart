import 'package:fpdart/fpdart.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

final class AuthenticationError {
  const AuthenticationError({required this.statusCode, required this.message});

  final int statusCode;
  final String message;
}

abstract class AuthenticationRepository {
  TaskEither<AuthenticationError, void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  TaskEither<AuthenticationError, void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  TaskEither<AuthenticationError, void> signOut();
}
