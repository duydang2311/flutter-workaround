import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/edit_profile/view/edit_profile_page.dart';
import 'package:workaround/home/view/home_page.dart';
import 'package:workaround/home_navigation/home_navigation.dart';
import 'package:workaround/home_navigation/widgets/home_scaffold.dart';
import 'package:workaround/profile/view/profile_page.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/sign_up/sign_up.dart';
import 'package:workaround/splash/splash.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
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
        return MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => HomeNavigationBloc(
              HomeNavigationState(
                currentIndex: navigationShell.currentIndex,
              ),
            ),
            child: BlocListener<HomeNavigationBloc, HomeNavigationState>(
              listener: (context, state) {
                // navigationShell.goBranch(
                //   state.currentIndex,
                //   initialLocation:
                //       state.currentIndex == navigationShell.currentIndex,
                // );
              },
              child: HomeScaffold(navigationShell: navigationShell),
            ),
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
