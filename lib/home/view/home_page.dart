import 'package:flutter/material.dart';
import 'package:workaround/home_navigation/home_navigation.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _HomeView(),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }
}

final class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home'));
  }
}
