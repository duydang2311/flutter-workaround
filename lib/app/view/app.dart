import 'package:animations/animations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:location_client/location_client.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_application_repository/work_application_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/authentication/bloc/authentication_bloc.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/router/router.dart';
import 'package:workaround/theme/theme.dart';

final class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.supabase,
    required this.appUserRepository,
    required this.profileRepository,
    required this.workRepository,
    required this.httpClient,
    required this.locationClient,
    required this.workApplicationRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final Supabase supabase;
  final AppUserRepository appUserRepository;
  final ProfileRepository profileRepository;
  final WorkRepository workRepository;
  final Client httpClient;
  final LocationClient locationClient;
  final WorkApplicationRepository workApplicationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: appUserRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: workRepository),
        RepositoryProvider.value(value: httpClient),
        RepositoryProvider.value(value: locationClient),
        RepositoryProvider.value(value: workApplicationRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: appUserRepository,
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
          // scrollBehavior: const MaterialScrollBehavior()
          //     .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
          theme: AppTheme.build(AppTheme.lighterOutline(lightColorScheme))
              .copyWith(
            extensions: [lightCustomColors],
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme:
              AppTheme.build(AppTheme.darkerOutline(darkColorScheme)).copyWith(
            extensions: [darkCustomColors],
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
              },
            ),
          ),
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
