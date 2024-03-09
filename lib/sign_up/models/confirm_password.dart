import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';

import 'package:workaround/sign_up/models/models.dart';

abstract base class ConfirmPasswordValidationError extends Equatable {
  const ConfirmPasswordValidationError();

  String getMessage(BuildContext context);

  @override
  List<Object?> get props => [];
}

final class ConfirmPasswordErrorEmpty extends ConfirmPasswordValidationError {
  const ConfirmPasswordErrorEmpty();

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signUpConfirmPasswordErrorEmpty;
  }
}

final class ConfirmPasswordErrorMismatch
    extends ConfirmPasswordValidationError {
  const ConfirmPasswordErrorMismatch();

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signUpConfirmPasswordErrorMismatch;
  }
}

final class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure(
      [super.value = '', this.original = const Password.pure()])
      : super.pure();
  const ConfirmPassword.dirty({required this.original, String value = ''})
      : super.dirty(value);

  final Password original;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return const ConfirmPasswordErrorEmpty();
    if (value != original.value) return const ConfirmPasswordErrorMismatch();
    return null;
  }
}
