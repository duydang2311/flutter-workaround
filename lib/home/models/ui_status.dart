enum UiStatus {
  none,
  loading;

  bool get isLoading => this == UiStatus.loading;
}
