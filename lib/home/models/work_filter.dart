enum WorkFilter {
  all,
  applying,
  own;

  bool get isAll => this == WorkFilter.all;
  bool get isApplying => this == WorkFilter.applying;
  bool get isOwn => this == WorkFilter.own;
}
