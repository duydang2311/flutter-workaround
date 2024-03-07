import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/authentication/bloc/authentication_bloc.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/splash/splash.dart';

final router = GoRouter(
  // initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => const Center(
      //   child: Text('Hello world'),
      // ),
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Center(
        child: Text('Hello world'),
      ),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
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
