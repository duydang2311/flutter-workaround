import 'package:authentication_repository/authentication_repository.dart';
import 'package:fpdart/fpdart.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract interface class AuthenticationRepository {
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
