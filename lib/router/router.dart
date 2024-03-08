import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/home/view/home_page.dart';
import 'package:workaround/home_navigation/home_navigation.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/splash/splash.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
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
              builder: (context, state) => const Center(child: Text('Profile')),
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
      pageBuilder: (context, state, navigationShell) =>
          _fadeTransitionPageBuilder(
        context: context,
        state: state,
        key: ValueKey(navigationShell.currentIndex),
        child: BlocProvider(
          create: (context) => HomeNavigationBloc(
            HomeNavigationState(currentIndex: navigationShell.currentIndex),
          ),
          child: BlocListener<HomeNavigationBloc, HomeNavigationState>(
            listener: (context, state) {
              navigationShell.goBranch(
                state.currentIndex,
                initialLocation:
                    state.currentIndex == navigationShell.currentIndex,
              );
            },
            child: Scaffold(
              bottomNavigationBar: const HomeBottomNavigationBar(),
              body: navigationShell,
            ),
          ),
        ),
      ),
      // builder: (context, state, navigationShell) {
      //   return BlocProvider(
      //     create: (context) => HomeNavigationBloc(
      //       HomeNavigationState(currentIndex: navigationShell.currentIndex),
      //     ),
      //     child: BlocListener<HomeNavigationBloc, HomeNavigationState>(
      //       listener: (context, state) {
      //         navigationShell.goBranch(
      //           state.currentIndex,
      //           initialLocation:
      //               state.currentIndex == navigationShell.currentIndex,
      //         );
      //       },
      //       child: Scaffold(
      //         bottomNavigationBar: const HomeBottomNavigationBar(),
      //         body: navigationShell,
      //       ),
      //     ),
      //   );
      // },
    ),
    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => _fadeTransitionPageBuilder(
        context: context,
        state: state,
        child: const SignInPage(),
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

CustomTransitionPage<T> _fadeTransitionPageBuilder<T extends Widget>({
  required BuildContext context,
  required GoRouterState state,
  required T child,
  LocalKey? key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutQuad).animate(animation),
        child: child,
      );
    },
  );
}
