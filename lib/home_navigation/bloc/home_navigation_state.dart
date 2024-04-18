part of 'home_navigation_bloc.dart';

final class HomeNavigationState extends Equatable {
  const HomeNavigationState({
    required this.scaffoldMap,
  });

  static const HomeNavigationState empty = HomeNavigationState(scaffoldMap: {});

  final Map<String, ScaffoldData> scaffoldMap;

  HomeNavigationState copyWith({Map<String, ScaffoldData>? scaffoldMap}) =>
      HomeNavigationState(scaffoldMap: scaffoldMap ?? this.scaffoldMap);

  @override
  List<Object?> get props => [scaffoldMap];
}

final class ScaffoldData extends Equatable {
  const ScaffoldData({
    this.appBar,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  List<Object?> get props => [appBar, floatingActionButton];
}
