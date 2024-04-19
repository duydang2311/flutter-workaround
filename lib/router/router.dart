import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/edit_profile/edit_profile.dart';
import 'package:workaround/home/view/home_page.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/map/view/map_page.dart';
import 'package:workaround/profile/view/profile_page.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/sign_up/sign_up.dart';
import 'package:workaround/splash/splash.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _mapNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _settingsNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage(key: ValueKey('splash'), child: SplashPage()),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              name: 'home',
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  name: 'create-work',
                  path: 'create-work',
                  pageBuilder: (context, state) => const MaterialPage(
                    key: ValueKey('create-work'),
                    child: CreateWorkPage(),
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
              path: '/maps',
              builder: (context, state) => const MapPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  name: 'edit-profile',
                  path: 'edit',
                  pageBuilder: (context, state) => const MaterialPage(
                    key: ValueKey('edit_profile'),
                    child: EditProfilePage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) =>
                  const Center(child: Text('Settings')),
            ),
          ],
        ),
      ],
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          key: state.pageKey,
          child: BlocProvider<HomeScaffoldBloc>(
            create: (context) => HomeScaffoldBloc(HomeScaffoldState.empty),
            child: HomeScaffold(navigationShell: navigationShell),
          ),
        );
      },
    ),
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignInPage(),
      ),
    ),
    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignUpPage(),
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
