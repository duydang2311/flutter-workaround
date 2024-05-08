import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workaround/map/map.dart';

final class WorkPopup extends StatelessWidget {
  const WorkPopup({required this.work, super.key});

  final MapWork work;

  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      work.description.toNullable() ??
                          'This work provides no description.',
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
