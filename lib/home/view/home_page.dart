import 'package:flutter/material.dart';
import 'package:workaround/theme/theme.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemedScaffoldBody(
      child: _HomeView(),
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
