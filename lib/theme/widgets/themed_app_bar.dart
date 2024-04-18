import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class ThemedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ThemedAppBar({
    this.title,
    this.actions,
    super.key,
  });

  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      leading: context.canPop()
          ? IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: context.pop,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
