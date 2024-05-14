enum WorkFilter {
  all,
  own;

  bool get isAll => this == WorkFilter.all;
  bool get isOwn => this == WorkFilter.own;
}
