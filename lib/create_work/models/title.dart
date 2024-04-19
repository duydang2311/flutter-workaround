import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

enum TitleValidationError { empty }

extension TitleValidationErrorX on TitleValidationError {
  String getMessage(BuildContext context) {
    switch (this) {
      case TitleValidationError.empty:
        return 'Enter a title for this work.';
    }
  }
}

final class Title extends FormzInput<String, TitleValidationError> {
  const Title.pure([super.value = '']) : super.pure();
  const Title.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) return TitleValidationError.empty;
    return null;
  }
}
