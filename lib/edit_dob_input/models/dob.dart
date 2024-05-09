import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

abstract class DobValidatorError {
  const DobValidatorError();

  void getMessage(BuildContext context);
}

class MinDobValidatorError extends DobValidatorError {
  @override
  String getMessage(BuildContext context) {
    return 'Invalid dob';
  }
}


class Dob extends FormzInput<DateTime, DobValidatorError> {
  Dob.pure() : super.pure(DateTime.now());
  Dob.dirty([DateTime? value]) : super.dirty(value!);

  @override
  DobValidatorError? validator(DateTime value) {
    if(value == null) return MinDobValidatorError();
    return null;
  }

}
