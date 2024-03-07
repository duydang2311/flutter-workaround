import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:workaround/authentication/bloc/authentication_bloc.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/router/router.dart';
import 'package:workaround/theme/theme.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final Supabase _supabase;
  late final AppUserRepository _userRepository;

  @override
  void initState() {
    _supabase = Supabase.instance;
    _authenticationRepository = SupabaseAuthenticationRepository(
      supabase: _supabase,
      supabaseRedirectUrl: 'io.supabase.flutterquickstart://login-callback/',
    );
    _userRepository = SupabaseAppUserRepository(
      supabase: _supabase,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

final class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<StatefulWidget> createState() => _AppViewState();
}

final class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          router.go('/home');
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          router.go('/sign-in');
        }
      },
      child: MaterialApp.router(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
