enum MapStatus {
  none,
  pending;

  bool get isPending => this == MapStatus.pending;
}
