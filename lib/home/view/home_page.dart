import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_navigation/home_navigation.dart';
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
    final bloc = context.read<HomeNavigationBloc>();
    bloc.add(
      HomeNavigationStateChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'home': ScaffoldData(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.push('/create-work');
              },
              child: const Icon(Icons.add),
            ),
          ),
        },
      ),
    );
    return const Center(child: Text('Home'));
  }
}
