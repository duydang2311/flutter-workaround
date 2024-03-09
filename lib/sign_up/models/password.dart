import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';

abstract base class PasswordValidationError extends Equatable {
  const PasswordValidationError();

  String getMessage(BuildContext context);

  @override
  List<Object?> get props => [];
}

final class EmptyPasswordError extends PasswordValidationError {
  const EmptyPasswordError();

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signUpPasswordErrorEmpty;
  }
}

final class MinLengthPasswordError extends PasswordValidationError {
  const MinLengthPasswordError(this.minLength) : super();

  final int minLength;

  @override
  String getMessage(BuildContext context) {
    return context.l10n.signUpPasswordErrorMinLength(minLength);
  }

  @override
  List<Object?> get props => [minLength];
}

final class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return const EmptyPasswordError();
    if (value.length < 8) return const MinLengthPasswordError(8);
    return null;
  }
}
