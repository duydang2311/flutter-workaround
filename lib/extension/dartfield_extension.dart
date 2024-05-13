import 'package:dartfield/dartfield.dart';

extension BitFieldX<T extends Enum> on BitField<T> {
  BitField<T> clone() => BitField<T>(value);
}
