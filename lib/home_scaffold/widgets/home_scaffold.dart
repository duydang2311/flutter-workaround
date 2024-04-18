import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/l10n/l10n.dart';

final class HomeScaffold extends StatelessWidget {
  const HomeScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _NavigationItem(
        location: '/home',
        label: l10n.homeBottomNavHomeLabel,
        icon: const Icon(Icons.home),
      ),
      _NavigationItem(
        location: '/maps',
        label: l10n.homeBottomNavMapLabel,
        icon: const Icon(Icons.map),
      ),
      _NavigationItem(
        location: '/profile',
        label: l10n.homeBottomNavProfileLabel,
        icon: const Icon(Icons.person),
      ),
      _NavigationItem(
        location: '/settings',
        label: l10n.homeBottomNavSettingsLabel,
        icon: const Icon(Icons.settings),
      ),
    ];

    return BlocProvider<HomeScaffoldBloc>(
      create: (context) => HomeScaffoldBloc(HomeScaffoldState.empty),
      child: BlocBuilder<HomeScaffoldBloc, HomeScaffoldState>(
        builder: (context, state) {
          final scaffoldData = state.scaffoldMap[
              navigationShell.shellRouteContext.routerState.topRoute?.name];
          return Scaffold(
            appBar: scaffoldData?.appBar,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              items: items
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: item.icon,
                      label: item.label,
                    ),
                  )
                  .toList(),
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
            body: navigationShell,
            floatingActionButton: scaffoldData?.floatingActionButton,
          );
        },
      ),
    );
  }
}

final class _NavigationItem {
  _NavigationItem({
    required this.location,
    required this.label,
    required this.icon,
    this.floatingActionButton,
  });

  final String location;
  final String label;
  final Icon icon;
  final Widget? floatingActionButton;
}
