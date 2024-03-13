import 'package:flutter/material.dart';

final class ThemedScaffoldBody extends StatelessWidget {
  const ThemedScaffoldBody({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ),
    );
    // return SafeArea(
    //   child: CustomScrollView(
    //     slivers: [
    //       SliverFillRemaining(
    //         hasScrollBody: false,
    //         child: Padding(
    //           padding: const EdgeInsets.all(8),
    //           child: child,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
