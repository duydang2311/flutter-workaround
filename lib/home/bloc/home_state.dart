part of 'home_bloc.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.works = const [],
    this.error = const Option.none(),
    this.timestamp = 0,
  });

  final List<HomeWork> works;
  final Option<UiError> error;
  final int timestamp;

  HomeState copyWith({
    List<HomeWork>? works,
    Option<UiError>? error,
    int? timestamp,
  }) =>
      HomeState(
        works: works ?? this.works,
        error: error ?? this.error,
        timestamp: timestamp ?? this.timestamp,
      );

  @override
  List<Object> get props => [works, error, timestamp];
}
