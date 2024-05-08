part of 'home_scaffold_bloc.dart';

sealed class HomeScaffoldEvent extends Equatable {
  const HomeScaffoldEvent();

  @override
  List<Object?> get props => [];
}

final class HomeScaffoldChanged extends HomeScaffoldEvent {
  const HomeScaffoldChanged({
    required this.scaffoldMap,
  });

  final Map<String, ScaffoldData> scaffoldMap;

  @override
  List<Object?> get props => [scaffoldMap];
}

final class HomeScaffoldCreateWorkRequested extends HomeScaffoldEvent {
  const HomeScaffoldCreateWorkRequested();
}

final class HomeScaffoldStatusChanged extends HomeScaffoldEvent {
  const HomeScaffoldStatusChanged({
    required this.status,
  });

  final HomeScaffoldStatus status;

  @override
  List<Object?> get props => [status];
}
