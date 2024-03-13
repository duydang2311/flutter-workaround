import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_navigation/home_navigation.dart';

final class HomeScaffold extends StatelessWidget {
  const HomeScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          HomeBottomNavigationBar(navigationShell: navigationShell),
      body: navigationShell,
    );
  }
}
