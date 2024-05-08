import 'package:flutter/material.dart';

final class WorkCluster extends StatelessWidget {
  const WorkCluster({required this.size, super.key});

  final int size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.tertiary.withOpacity(0.1),
          ),
          color: colorScheme.tertiaryContainer,
        ),
        child: Center(
          child: Text(
            '+$size',
            style: TextStyle(
              color: colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
