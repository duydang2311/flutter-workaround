part of 'home_navigation_bloc.dart';

sealed class HomeNavigationEvent extends Equatable {
  const HomeNavigationEvent();

  @override
  List<Object?> get props => [];
}

final class HomeNavigationStateChanged extends HomeNavigationEvent {
  const HomeNavigationStateChanged({
    required this.scaffoldMap,
  });

  final Map<String, ScaffoldData> scaffoldMap;

  @override
  List<Object?> get props => [scaffoldMap];
}

final class HomeNavigationCreateWorkRequested extends HomeNavigationEvent {
  const HomeNavigationCreateWorkRequested();
}
