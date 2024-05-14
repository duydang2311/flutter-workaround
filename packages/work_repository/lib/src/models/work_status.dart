enum WorkStatus {
  open,
  closed;

  bool get isOpen => this == WorkStatus.open;
  bool get isClosed => this == WorkStatus.closed;
}
