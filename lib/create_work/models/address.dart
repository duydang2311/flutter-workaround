import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

enum AddressValidationError { empty }

extension AddressValidationErrorX on AddressValidationError {
  String getMessage(BuildContext context) {
    switch (this) {
      case AddressValidationError.empty:
        return 'Enter work address.';
    }
  }
}

final class Address extends FormzInput<String, AddressValidationError> {
  const Address.pure([super.value = '']) : super.pure();
  const Address.dirty([super.value = '']) : super.dirty();

  @override
  AddressValidationError? validator(String value) {
    if (value.isEmpty) return AddressValidationError.empty;
    return null;
  }
}
