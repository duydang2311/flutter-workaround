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

    return BlocBuilder<HomeScaffoldBloc, HomeScaffoldState>(
      builder: (context, state) {
        final scaffoldData = state.scaffoldMap[
            navigationShell.shellRouteContext.routerState.topRoute?.name];
        return Scaffold(
          appBar: scaffoldData?.appBar,
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: navigationShell.currentIndex,
            destinations: items
                .map(
                  (item) => NavigationDestination(
                    icon: item.icon,
                    label: item.label,
                  ),
                )
                .toList(),
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
          floatingActionButton: scaffoldData?.floatingActionButton,
          body: navigationShell,
        );
      },
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
