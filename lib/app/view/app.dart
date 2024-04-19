import 'package:authentication_repository/authentication_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/authentication/bloc/authentication_bloc.dart';
import 'package:workaround/dart_define.gen.dart';
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
  late final AppUserRepository _appUserRepository;
  late final ProfileRepository _profileRepository;
  late final WorkRepository _workRepository;

  @override
  void initState() {
    _supabase = Supabase.instance;
    _authenticationRepository = SupabaseAuthenticationRepository(
      supabase: _supabase,
      supabaseRedirectUrl: 'io.supabase.flutterquickstart://login-callback/',
      webClientId: DartDefine.googleOauthWebClientId,
      iosClientId: DartDefine.googleOauthIosClientId,
    );
    _appUserRepository = SupabaseAppUserRepository(
      supabase: _supabase,
    );
    _profileRepository = SupabaseProfileRepository(
      supabase: _supabase,
      appUserRepository: _appUserRepository,
    );
    _workRepository = SupabaseWorkRepository(supabase: _supabase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _appUserRepository),
        RepositoryProvider.value(value: _profileRepository),
        RepositoryProvider.value(value: _workRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _appUserRepository,
        ),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              router.go('/home');
            } else if (state.status == AuthenticationStatus.unauthenticated) {
              router.go('/sign-in');
            }
          },
          child: const AppView(),
        ),
      ),
    );
  }
}

final class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<StatefulWidget> createState() => _AppViewState();
}

CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));

final class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = AppTheme.lighterOutline(lightDynamic.harmonized());
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(
          //   secondary: AppTheme.lightColorScheme.primary,
          // );
          // (Optional) If applicable, harmonize custom colors.
          lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = AppTheme.darkerOutline(darkDynamic.harmonized());
          // darkColorScheme = darkColorScheme.copyWith(
          //   secondary: AppTheme.darkColorScheme.primary,
          // );
          darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = AppTheme.lightColorScheme;
          darkColorScheme = AppTheme.darkColorScheme;
        }

        return MaterialApp.router(
          theme: AppTheme.build(AppTheme.lighterOutline(lightColorScheme))
              .copyWith(extensions: [lightCustomColors]),
          darkTheme: AppTheme.build(AppTheme.darkerOutline(darkColorScheme))
              .copyWith(extensions: [darkCustomColors]),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      danger: danger.harmonizeWith(dynamic.primary),
    );
  }
}
