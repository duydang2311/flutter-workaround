import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/edit_profile/edit_profile.dart';
import 'package:workaround/home/view/home_page.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/map/view/map_page.dart';
import 'package:workaround/edit_dob_input/edit_dob_input.dart';
import 'package:workaround/edit_gender_input/view/edit_gender_input_page.dart';
import 'package:workaround/edit_name_input/view/edit_name_input_page.dart';
import 'package:workaround/edit_profile/view/edit_profile_page.dart';
import 'package:workaround/home/view/home_page.dart';
import 'package:workaround/home_navigation/widgets/home_scaffold.dart';
import 'package:workaround/img_picker/img_pick.dart';
import 'package:workaround/profile/view/profile_page.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/sign_up/sign_up.dart';
import 'package:workaround/splash/splash.dart';
import 'package:workaround/work/work.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _mapNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'splash',
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage(key: ValueKey('splash'), child: SplashPage()),
    ),
    StatefulShellRoute(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) =>
          BlocProvider<HomeScaffoldBloc>(
        create: (context) => HomeScaffoldBloc(HomeScaffoldState.empty),
        child: HomeScaffold(
          navigationShell: navigationShell,
          children: children,
        ),
      ),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              name: 'home',
              path: '/home',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const HomePage(),
              ),
              routes: [
                GoRoute(
                  name: 'create-work',
                  path: 'create-work',
                  pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: const CreateWorkPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _mapNavigatorKey,
          routes: [
            GoRoute(
              name: 'map',
              path: '/maps',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const MapPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              name: 'profile',
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  name: 'edit-profile',
                  path: 'edit',
                  pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: const EditProfilePage(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit-display-name',
                      pageBuilder: (context, state) => const MaterialPage(
                        key: ValueKey('edit_display_name'),
                        child: EditNameInputPage(),
                      ),
                    ),
                    GoRoute(
                      path: 'edit-dob',
                      pageBuilder: (context, state) => const MaterialPage(
                        key: ValueKey('edit_dob'),
                        child: EditDobInputPage(),
                      ),
                    ),
                    GoRoute(
                      path: 'edit-gender',
                      pageBuilder: (context, state) => const MaterialPage(
                        key: ValueKey('edit_gender'),
                        child: EditGenderInputPage(),
                      ),
                    ),
                    GoRoute(
                      path: 'edit-avatar',
                      pageBuilder: (context, state) => const MaterialPage(
                        key: ValueKey('edit_avatar'),
                        child: ImagePickerPage(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              name: 'settings',
              path: '/settings',
              builder: (context, state) =>
                  const Center(child: Text('Settings')),
            ),
          ],
        ),
      ],
      // pageBuilder: (context, state, navigationShell) {
      //   log('_rebuld');
      //   return NoTransitionPage(
      //     key: state.pageKey,
      //     child: BlocProvider<HomeScaffoldBloc>(
      //       create: (context) => HomeScaffoldBloc(HomeScaffoldState.empty),
      //       child: HomeScaffold(navigationShell: navigationShell),
      //     ),
      //   );
      // },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'works',
      path: '/works/:id',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: WorkPage(id: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/sign-in',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SignInPage(),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/sign-up',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SignUpPage(),
      ),
    ),
  ],
  // redirect: (context, state) {
  //   final bloc = context.read<AuthenticationBloc>();
  //   final loggedIn = bloc.state.status == AuthenticationStatus.authenticated;
  //   final loggingIn = state.matchedLocation == '/sign-in';

  //   print('${bloc.state} -> ${state.fullPath}');
  //   if (!loggedIn) return '/sign-in';
  //   if (loggingIn) return '/';
  //   return null;
  // },
);
