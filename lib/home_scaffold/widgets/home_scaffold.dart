import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/l10n/l10n.dart';

final class HomeScaffold extends StatelessWidget {
  const HomeScaffold({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

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
      buildWhen: (previous, current) =>
          previous.scaffoldMap != current.scaffoldMap,
      builder: (context, state) {
        final scaffoldData =
            state.scaffoldMap[switch (navigationShell.currentIndex) {
          0 => switch (
                navigationShell.shellRouteContext.routerState.topRoute?.name) {
              'create-work' => 'create-work',
              _ => 'home',
            },
          1 => 'map',
          2 => 'profile',
          3 => 'settings',
          _ => '',
        }];
        log('_ ${navigationShell.shellRouteContext.route.routes}');
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
          drawer: scaffoldData?.drawer,
          // body: PageTransitionSwitcher(
          //   transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          //       FadeThroughTransition(
          //           animation: primaryAnimation,
          //           secondaryAnimation: secondaryAnimation,
          //           child: child,),
          //   child: children[navigationShell.currentIndex],
          // ),
          body: _AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          ),
        );
      },
    );
  }
}

class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const inCurve = Cubic(0, 0, 0.2, 1);
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return Opacity(
            opacity: index == currentIndex ? 1 : 0,
            child: AnimatedScale(
              scale: index == currentIndex ? 1 : 0.92,
              curve: inCurve,
              duration: const Duration(milliseconds: 300),
              child: _branchNavigatorWrapper(index, navigator),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
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
