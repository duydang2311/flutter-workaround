import 'package:formz/formz.dart';

final class Description extends FormzInput<String, void> {
  const Description.pure([super.value = '']) : super.pure();
  const Description.dirty([super.value = '']) : super.dirty();

  @override
  void validator(String value) {}
}
