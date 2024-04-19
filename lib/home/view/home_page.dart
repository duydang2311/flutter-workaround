import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
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
    final bloc = context.read<HomeScaffoldBloc>();
    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'home': ScaffoldData(
            appBar: const ThemedAppBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.pushNamed('create-work');
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
