import 'package:flutter/material.dart';
import 'package:workaround/theme/theme.dart';

final class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ThemedAppBar(
        title: ThemedAppBarTitle('Edit profile'),
      ),
      body: ThemedScaffoldBody(
        child: _EditProfileView(),
      ),
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
