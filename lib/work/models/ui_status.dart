import 'package:dartfield/dartfield.dart';

enum UiStatus {
  none,
  loading,
  fabLoading;
}

extension UiStatusX on BitField<UiStatus> {
  bool get isLoading => contains(UiStatus.loading);
  bool get isFABLoading => contains(UiStatus.fabLoading);
}
