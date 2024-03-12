import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaround/authentication/authentication.dart';
import 'package:workaround/home_navigation/home_navigation.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: HomeBottomNavigationBar(),
      body: SafeArea(child: _ProfileView()),
    );
  }
}

final class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Sign out'),
        onPressed: () {
          context
              .read<AuthenticationBloc>()
              .add(const AuthenticationSignOutRequested());
        },
      ),
    );
  }
}
