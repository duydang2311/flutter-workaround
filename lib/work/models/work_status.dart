enum WorkStatus {
  none,
  loading;

  bool get isLoading => this == WorkStatus.loading;
}
