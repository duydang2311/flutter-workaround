import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class ThemedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ThemedAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: theme.colorScheme.primaryContainer,
      leading: context.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: context.pop,
            )
          : null,
      forceMaterialTransparency: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
