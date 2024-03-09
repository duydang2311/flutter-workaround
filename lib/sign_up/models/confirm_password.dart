import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';

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

final class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure([super.value = '']) : super.pure();
  const ConfirmPassword.dirty([super.value = '']) : super.dirty();

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return const ConfirmPasswordErrorEmpty();
    return null;
  }
}
