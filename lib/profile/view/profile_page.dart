import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:workaround/authentication/authentication.dart';
import 'package:workaround/profile/bloc/profile_bloc.dart';
import 'package:workaround/profile/models/models.dart';
import 'package:workaround/theme/theme.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: RepositoryProvider.of<ProfileRepository>(context),
      ),
      child: const ThemedScaffoldBody(
        child: _ProfileView(),
      ),
    );
  }
}

final class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) => const Column(
        children: [
          _ProfileStats(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

final class _ProfileStats extends StatelessWidget {
  const _ProfileStats();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return ThemedCircularProgressIndicator(
            dimension: MediaQuery.sizeOf(context).shortestSide / 1.5,
          );
        }

        final theme = Theme.of(context);
        return state.profile.match(
          () => const Text('No profile yet!'),
          (profile) => Column(
            children: [
              SizedBox.square(
                dimension: MediaQuery.sizeOf(context).shortestSide / 1.5,
                child: CircleAvatar(
                  backgroundImage: profile.imageUrl.isNotEmpty
                      ? NetworkImage(
                          profile.imageUrl,
                        )
                      : null,
                  child: profile.imageUrl.isEmpty
                      ? RandomAvatar(
                          profile.id,
                          trBackground: true,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.displayName,
                style: theme.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Text('user@gmail.com'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'General',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.person_rounded,
                      ),
                      title: const Text('Edit profile'),
                      subtitle: const Text(
                        'Change profile picture, display name, phone number...',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push('/profile/edit');
                      },
                    ),
                    Divider(
                      color: theme.colorScheme.outline,
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app_rounded),
                      title: const Text('Sign out'),
                      subtitle: const Text(
                          'Log out of the current session and navigate back to sign in page.'),
                      onTap: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(const AuthenticationSignOutRequested());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
