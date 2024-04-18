import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaround/home_navigation/home_navigation.dart';
import 'package:workaround/theme/theme.dart';

final class CreateWorkPage extends StatelessWidget {
  const CreateWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeNavigationBloc>();
    bloc.add(
      HomeNavigationStateChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'create-work': const ScaffoldData(
            appBar: ThemedAppBar(
              title: ThemedAppBarTitle('Create work'),
            ),
          ),
        },
      ),
    );
    return const ThemedScaffoldBody(
      child: _CreateWorkView(),
    );
  }
}

final class _CreateWorkView extends StatelessWidget {
  const _CreateWorkView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Create a work...'));
  }
}
