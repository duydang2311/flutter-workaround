import 'package:flutter/material.dart';

final class ThemedScaffoldBody extends StatelessWidget {
  const ThemedScaffoldBody({
    required this.child,
    this.middle = true,
    super.key,
  });

  final Widget child;
  final bool middle;

  @override
  Widget build(BuildContext context) {
    Widget widget = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
    if (middle) widget = Center(child: widget);
    return SafeArea(
      child: widget,
    );
  }
}
