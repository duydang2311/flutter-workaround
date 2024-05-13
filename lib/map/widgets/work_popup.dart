import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:workaround/map/map.dart';

final class WorkPopup extends StatelessWidget {
  const WorkPopup({required this.work, super.key});

  final MapWork work;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final createdDateFormat = Jiffy.parseFromDateTime(work.createdAt).fromNow();

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                visualDensity: VisualDensity.compact,
                dense: true,
                horizontalTitleGap: 8,
                leading: const Icon(Icons.pin_drop_rounded),
                title: Text(
                  work.address,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      horizontalTitleGap: 8,
                      leading: const Icon(Icons.person_rounded),
                      title: Text(work.ownerName),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      horizontalTitleGap: 8,
                      leading: const Icon(Icons.directions_walk_rounded),
                      title: Text('${((work.distance / 1000) * 10).round()}km'),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      horizontalTitleGap: 8,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time_rounded),
                      title: Text(
                        '${createdDateFormat[0].toUpperCase()}${createdDateFormat.substring(1)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints.tight(const Size.fromHeight(120)),
                child: SingleChildScrollView(
                  child: work.description.match(
                    () => Text(
                      'No description specified.',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    Text.new,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                        'works',
                        pathParameters: {'id': work.id},
                      );
                    },
                    child: const Text('View details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
