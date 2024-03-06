import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';

sealed class PasswordValidationError {
  const PasswordValidationError();

  String getMessage(BuildContext context);
}

final class EmptyPasswordError extends PasswordValidationError {
  const EmptyPasswordError();

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signInPasswordErrorEmpty;
  }
}

final class MinLengthPasswordError extends PasswordValidationError {
  const MinLengthPasswordError(this.length);

  final int length;

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signInPasswordErrorMinLength(length);
  }
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return const EmptyPasswordError();
    if (value.length < 8) return const MinLengthPasswordError(8);
    return null;
  }
}
