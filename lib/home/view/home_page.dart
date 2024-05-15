import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location_client/location_client.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';
import 'package:work_repository/work_repository.dart' hide Work;
import 'package:workaround/home/bloc/search_bloc.dart';
import 'package:workaround/home/home.dart';
import 'package:workaround/home/view/home_search.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/theme/theme.dart';
import 'package:workaround/work/work.dart';

final class HomePage extends StatelessWidget {
  const HomePage({this.filter = WorkFilter.all, super.key});

  final WorkFilter filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        filter: filter,
        workRepository: RepositoryProvider.of<WorkRepository>(context),
        locationClient: RepositoryProvider.of<LocationClient>(context),
        appUserRepository: RepositoryProvider.of<AppUserRepository>(context),
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
    final homeBloc = context.read<HomeBloc>();
    final scaffoldData = ScaffoldData(
      appBar: ThemedAppBar(
        title: const ThemedAppBarTitle('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              (await showSearch(
                context: context,
                delegate: HomeSearch(
                  bloc: SearchBloc(
                    workRepository: RepositoryProvider.of<WorkRepository>(
                      context,
                    ),
                  ),
                ),
                useRootNavigator: true,
              ))
                  ?.match(() {}, (t) {
                GoRouter.of(context).pushNamed(
                  'works',
                  pathParameters: {'id': t.id},
                );
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('create-work');
        },
        child: const Icon(Icons.add),
      ),
      drawer: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) => NavigationDrawer(
          selectedIndex: switch (state.filter) {
            WorkFilter.all => 0,
            WorkFilter.own => 1,
          },
          onDestinationSelected: (index) {
            homeBloc.add(
              HomeWorkFilterChanged(
                switch (index) {
                  0 => WorkFilter.all,
                  1 => WorkFilter.own,
                  _ => WorkFilter.all,
                },
              ),
            );
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
              child: Text(
                'Works',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            NavigationDrawerDestination(
              icon: switch (state.filter) {
                WorkFilter.all => const Icon(Icons.view_list_rounded),
                _ => const Icon(Icons.view_list_outlined),
              },
              label: const Text('Open works'),
            ),
            NavigationDrawerDestination(
              icon: switch (state.filter) {
                WorkFilter.own => const Icon(Icons.person_rounded),
                _ => const Icon(Icons.person_outline),
              },
              label: const Text('My works'),
            ),
          ],
        ),
      ),
    );

    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'home': scaffoldData,
        },
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              current.error.isSome() && previous.error != current.error,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toNullable()!.message),
              ),
            );
          },
        ),
      ],
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<HomeBloc>()
              ..add(const HomeRefreshRequested());
            await bloc.stream.first;
          },
          child: const _WorkList(),
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
      buildWhen: (previous, current) =>
          (previous.works, previous.status) != (current.works, current.status),
      builder: (context, state) => Skeletonizer(
        enabled: state.status.isLoading,
        child: InfiniteList(
          onFetchData: () {
            context.read<HomeBloc>().add(const HomeMoreWorksRequested());
          },
          isLoading: state.status.isLoading,
          itemCount: state.works.length,
          hasReachedMax: state.hasReachedMax,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            final work = state.works[index];
            return ListTile(
              key: ValueKey(work.id),
              onTap: () async {
                final changed = await GoRouter.of(context).pushNamed(
                  'works',
                  pathParameters: {'id': work.id},
                );
                if (context.mounted && changed is Work) {
                  context.read<HomeBloc>().add(
                        HomeWorkChanged(
                          id: changed.id,
                          status: changed.status,
                        ),
                      );
                }
              },
              title: Text(work.title),
              subtitle: Column(
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
                      if (work.status.isClosed)
                        Icon(
                          Icons.lock_rounded,
                          color: colorScheme.error,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (work.description.isSome())
                    Text(
                      work.description.toNullable()!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
