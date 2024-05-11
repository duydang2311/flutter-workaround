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
