import 'package:infrastructure/infrastructure.dart';

final class ProfileError extends SupabaseError {
  const ProfileError({
    required super.message,
    super.code = '-',
  });
  const ProfileError.unknown() : super.unknown();
  ProfileError.fromException(super.authException)
      : super.fromException();
}