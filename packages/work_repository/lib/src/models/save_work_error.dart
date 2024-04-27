import 'package:shared_kernel/shared_kernel.dart';

final class SaveWorkError extends SupabaseError {
  const SaveWorkError.unknown() : super.unknown();
  SaveWorkError.fromAuthException(super.authException) : super.fromException();
  SaveWorkError.fromException(Exception exception)
      : super(
          code: '-',
          message: exception.toString(),
        );
}
