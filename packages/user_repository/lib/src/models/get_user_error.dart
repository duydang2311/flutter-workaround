import 'package:infrastructure/infrastructure.dart';

final class GetUserError extends SupabaseError {
  const GetUserError.unknown() : super.unknown();
  GetUserError.fromException(super.authException) : super.fromException();
}
