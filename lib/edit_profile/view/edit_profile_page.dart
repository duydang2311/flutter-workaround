import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/theme/theme.dart';

final class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeScaffoldBloc>();
    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'edit-profile': const ScaffoldData(
            appBar: ThemedAppBar(
              title: ThemedAppBarTitle('Edit profile'),
            ),
          ),
        },
      ),
    );
    return const ThemedScaffoldBody(
      child: _EditProfileView(),
    );
  }
}

final class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Hello'));
  }
}
