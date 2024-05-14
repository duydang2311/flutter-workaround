part of 'home_scaffold_bloc.dart';

final class HomeScaffoldState extends Equatable {
  const HomeScaffoldState({
    required this.scaffoldMap,
    required this.status,
  });

  static const HomeScaffoldState empty = HomeScaffoldState(
    scaffoldMap: {},
    status: HomeScaffoldStatus.none,
  );

  final Map<String, ScaffoldData> scaffoldMap;
  final HomeScaffoldStatus status;

  HomeScaffoldState copyWith({
    Map<String, ScaffoldData>? scaffoldMap,
    HomeScaffoldStatus? status,
  }) =>
      HomeScaffoldState(
        scaffoldMap: scaffoldMap ?? this.scaffoldMap,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [scaffoldMap, status];
}

final class ScaffoldData extends Equatable {
  const ScaffoldData({
    this.appBar,
    this.floatingActionButton,
    this.drawer,
  });

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;

  @override
  List<Object?> get props => [appBar, floatingActionButton, drawer];
}
