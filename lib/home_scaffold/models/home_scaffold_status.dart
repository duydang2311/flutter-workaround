enum HomeScaffoldStatus {
  none,
  pending;

  bool get isPending => this == HomeScaffoldStatus.pending;
}
