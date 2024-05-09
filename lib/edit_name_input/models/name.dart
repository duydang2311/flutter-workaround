


import 'package:flutter/material.dart';
import 'package:formz/formz.dart';


sealed class NameValidatorError  {
  const NameValidatorError();

  String getMessage(BuildContext context);
}

class MinNameValidatorError extends NameValidatorError {
  @override
  String getMessage(BuildContext context) {
    return 'Lenght of name not < 4';
  }
}
class ExistNameValidatorError extends NameValidatorError {

  @override
  String getMessage(BuildContext context) {
    return 'Name is already used';
  }
}
class Name extends FormzInput <String, NameValidatorError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidatorError? validator(String value) {
    if(value.length < 4) return MinNameValidatorError();
    return null;
  }
}