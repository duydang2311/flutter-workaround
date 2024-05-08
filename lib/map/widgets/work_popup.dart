import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workaround/map/map.dart';

final class WorkPopup extends StatelessWidget {
  const WorkPopup({required this.work, super.key});

  final MapWork work;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Card.outlined(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              // leading: IconButton.filledTonal(
              //   onPressed: () {},
              //   icon: const Icon(Icons.work),
              //   tooltip: 'View details',
              // ),
              title: Text(work.title),
              isThreeLine: true,
              subtitle: Skeletonizer(
                enabled: work.popupStatus.isPending,
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(const Size.fromHeight(200)),
                  child: SingleChildScrollView(
                    child: work.description.match(
                      () => Text(
                        'The author has not provided job description.',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                      Text.new,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('View details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
