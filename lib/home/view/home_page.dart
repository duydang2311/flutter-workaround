import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location_client/location_client.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/home/bloc/home_bloc.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/theme/theme.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        workRepository: RepositoryProvider.of<WorkRepository>(context),
        locationClient: RepositoryProvider.of<LocationClient>(context),
      )..add(const HomeInitialized()),
      child: const _HomeView(),
    );
  }
}

final class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeScaffoldBloc>();
    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'home': ScaffoldData(
            appBar: const ThemedAppBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.pushNamed('create-work');
              },
              child: const Icon(Icons.add),
            ),
          ),
        },
      ),
    );

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          current.error.isSome() && previous.error != current.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toNullable()!.message),
          ),
        );
      },
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<HomeBloc>()
              ..add(const HomeRefreshRequested());
            await bloc.stream.first;
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _WorkList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _WorkList extends StatelessWidget {
  const _WorkList();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.works != current.works,
      builder: (context, state) => Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: List.generate(state.works.length, (index) {
            final work = state.works[index];
            return ListTile(
              key: ValueKey(work.id),
              onTap: () {
                GoRouter.of(context).pushNamed(
                  'works',
                  pathParameters: {'id': work.id},
                );
              },
              title: Text(work.title),
              subtitle: work.description.match(
                () => null,
                (description) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pin_drop),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                work.address,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 8),
                            Text(work.ownerName),
                          ],
                        ),
                        if (work.distance.isSome())
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_walk),
                              const SizedBox(width: 8),
                              Text(
                                '${((work.distance.toNullable()! / 1000) * 10).round() / 10}km',
                              ),
                            ],
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_filled_rounded),
                            const SizedBox(width: 8),
                            Text(
                              Jiffy.parseFromDateTime(work.createdAt).fromNow(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ).toList(),
      ),
    );
  }
}
