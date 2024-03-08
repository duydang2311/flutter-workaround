part of 'router_bloc.dart';

sealed class RouterEvent extends Equatable {
  const RouterEvent();

  @override
  List<Object?> get props => [];
}

final class HomeNavigationBranchChangeRequested extends RouterEvent {
  const HomeNavigationBranchChangeRequested({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}
