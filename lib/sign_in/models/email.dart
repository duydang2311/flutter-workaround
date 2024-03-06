import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';

enum EmailValidationError { empty, invalid }

extension EmailValidationErrorX on EmailValidationError {
  String getMessage(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case EmailValidationError.empty:
        return l10n.signInEmailErrorEmpty;
      case EmailValidationError.invalid:
        return l10n.signInEmailErrorInvalid;
    }
  }
}

class Email extends FormzInput<String, EmailValidationError>
    with FormzInputErrorCacheMixin {
  Email.pure([super.value = '']) : super.pure();
  Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}
