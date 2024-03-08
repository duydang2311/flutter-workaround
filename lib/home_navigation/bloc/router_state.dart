part of 'router_bloc.dart';

final class HomeNavigationState extends Equatable {
  const HomeNavigationState({required this.currentIndex});

  final int currentIndex;

  HomeNavigationState copyWith({int? currentIndex}) =>
      HomeNavigationState(currentIndex: currentIndex ?? this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}
