import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

abstract class GenderValidationError {
  const GenderValidationError();

  void getMessage(BuildContext context);
}

class MinDobValidatorError extends GenderValidationError {
  @override
  String getMessage(BuildContext context) {
    return 'Invalid gender';
  }
}


class Gender extends FormzInput<String, GenderValidationError> {
  const Gender.pure() : super.pure('');
  const Gender.dirty([super.value = '']) : super.dirty();

  @override
  GenderValidationError? validator(String value) {
    if(value == null) return MinDobValidatorError();
    return null;
  }

}
