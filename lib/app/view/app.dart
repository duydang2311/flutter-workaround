import 'package:flutter/material.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SignInPage(),
    );
  }
}
