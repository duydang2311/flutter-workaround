import 'package:infrastructure/infrastructure.dart';

final class AuthenticationError extends SupabaseError {
  const AuthenticationError.unknown() : super.unknown();
  AuthenticationError.fromException(super.authException)
      : super.fromException();
}
