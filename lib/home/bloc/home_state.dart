part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.works = const [],
    this.error = const Option.none(),
    this.timestamp = 0,
    this.filter = WorkFilter.all,
    this.status = UiStatus.none,
    this.hasReachedMax = false,
  });

  final List<HomeWork> works;
  final Option<UiError> error;
  final WorkFilter filter;
  final UiStatus status;
  final int timestamp;
  final bool hasReachedMax;

  HomeState copyWith({
    List<HomeWork>? works,
    Option<UiError>? error,
    WorkFilter? filter,
    UiStatus? status,
    int? timestamp,
    bool? hasReachedMax,
  }) =>
      HomeState(
        works: works ?? this.works,
        error: error ?? this.error,
        filter: filter ?? this.filter,
        status: status ?? this.status,
        timestamp: timestamp ?? this.timestamp,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object> get props => [works, error, filter, status, timestamp];
}
