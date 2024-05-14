part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

final class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

final class HomeWorkFilterChanged extends HomeEvent {
  const HomeWorkFilterChanged(this.filter);

  final WorkFilter filter;

  @override
  List<Object> get props => [filter];
}

final class HomeWorkChanged extends HomeEvent {
  const HomeWorkChanged({required this.id, required this.status});

  final String id;
  final WorkStatus status;

  @override
  List<Object> get props => [id, status];
}

final class HomeMoreWorksRequested extends HomeEvent {
  const HomeMoreWorksRequested();
}
