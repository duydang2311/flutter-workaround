import 'package:flutter/material.dart';
import 'package:workaround/theme/theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: ThemedCircularProgressIndicator()),
    );
  }
}
