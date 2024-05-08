enum PopupStatus {
  none,
  pending;

  bool get isPending => this == PopupStatus.pending;
}
