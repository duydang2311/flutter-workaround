import 'package:shared_kernel/shared_kernel.dart';

final class GetUserError extends SupabaseError {
  const GetUserError.unknown() : super.unknown();
  GetUserError.fromException(super.authException) : super.fromException();
}
