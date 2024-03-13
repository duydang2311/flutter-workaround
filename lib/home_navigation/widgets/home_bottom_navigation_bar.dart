import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_navigation/home_navigation.dart';
import 'package:workaround/l10n/l10n.dart';

final class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({required this.navigationShell, super.key});

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

    return BlocBuilder<HomeNavigationBloc, HomeNavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentIndex,
          items: items
              .map(
                (item) =>
                    BottomNavigationBarItem(icon: item.icon, label: item.label),
              )
              .toList(),
          onTap: (index) {
            context
                .read<HomeNavigationBloc>()
                .add(HomeNavigationBranchChangeRequested(index: index));
            navigationShell.goBranch(index);
          },
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
  });

  final String location;
  final String label;
  final Icon icon;
}
