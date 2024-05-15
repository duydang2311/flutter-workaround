import 'package:flutter/material.dart';

final class ThemedCircularProgressIndicator extends StatelessWidget {
  const ThemedCircularProgressIndicator({
    super.key,
    this.dimension,
    this.padding,
    this.strokeWidth,
  });

  final double? dimension;
  final EdgeInsetsGeometry? padding;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension ?? 20,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(1),
        child: CircularProgressIndicator.adaptive(
          strokeWidth: strokeWidth ?? 2,
        ),
      ),
    );
  }
}
