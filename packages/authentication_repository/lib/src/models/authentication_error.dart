import 'package:shared_kernel/shared_kernel.dart';

final class AuthenticationError extends SupabaseError {
  const AuthenticationError({
    required super.message,
    super.code = '-',
  });
  const AuthenticationError.unknown() : super.unknown();
  AuthenticationError.fromException(super.authException)
      : super.fromException();
}
