part of 'home_scaffold_bloc.dart';

final class HomeScaffoldState extends Equatable {
  const HomeScaffoldState({
    required this.scaffoldMap,
  });

  static const HomeScaffoldState empty = HomeScaffoldState(scaffoldMap: {});

  final Map<String, ScaffoldData> scaffoldMap;

  HomeScaffoldState copyWith({Map<String, ScaffoldData>? scaffoldMap}) =>
      HomeScaffoldState(scaffoldMap: scaffoldMap ?? this.scaffoldMap);

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
