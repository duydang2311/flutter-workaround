import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:workaround/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:workaround/edit_profile/models/models.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/l10n/l10n.dart';
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
      )
    );
    return BlocProvider(
      create: (context) =>
          EditProfileBloc(profileRepository: RepositoryProvider.of(context)),
      child: const ThemedScaffoldBody(
          child: _EditProfileView(),
        ),
    );
  }
}

final class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return ThemedCircularProgressIndicator(
              dimension: MediaQuery.sizeOf(context).shortestSide / 1.5,
            );
          }
          return state.profile.match(
            () => const Text('Sorry somethings wrong in here'),
            (profile) => Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(2),
                ),
                Stack(
                  children: [
                    SizedBox.square(
                      dimension: MediaQuery.sizeOf(context).shortestSide / 2,
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
                    Positioned(
                      bottom: 0,
                      right: 17,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.blue,
                            child: IconButton(
                              iconSize: 26,
                            onPressed: () => context.go('/profile/edit/edit-avatar'),                                
                            icon: const Icon(
                                color: Colors.white,
                                Icons.add_a_photo,
                                ),
                               
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const _NameInput(),
                const SizedBox(height: 25),
                _DobInput(),
                const SizedBox(height: 25),
                _GenderInput(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        return state.profile.match(
          () => const Text('Something is wrong in here'),
          (profile) => TextFormField(
            controller: TextEditingController(
              text: profile.displayName,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Display name',
              suffixIcon: InkWell(
                onTap: () {
                  context.go('/profile/edit/edit-display-name');
                },
                child: const Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DobInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        return state.profile.match(
          () => const Text('Something is wrong in here'),
          (profile) => Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: profile.dob != null
                        ? profile.dob.toString()
                        : 'DD/MM/YYYY',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: InkWell(
                      onTap: () {
                        context.go('/profile/edit/edit-dob');
                      },
                      child: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GenderInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        return state.profile.match(
          () => const Text('Something is wrong in here'),
          (profile) => Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(
                    text: profile.gender ?? '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    suffixIcon: InkWell(
                      onTap: () {
                        context.go('/profile/edit/edit-gender');
                      },
                      child: const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
