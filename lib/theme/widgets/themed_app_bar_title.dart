import 'package:flutter/material.dart';

final class ThemedAppBarTitle extends StatelessWidget {
  const ThemedAppBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
