import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/theme/theme.dart';
import 'package:workaround/work/bloc/work_bloc.dart';

final class WorkPage extends StatelessWidget {
  const WorkPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkBloc(
        id: id,
        workRepository: RepositoryProvider.of<WorkRepository>(context),
      )..add(const WorkInitialized()),
      child: Scaffold(
        appBar: AppBar(
          title: _WorkAppBarTitle(),
        ),
        floatingActionButton: _WorkFloatingActionButton(),
        body: const _WorkView(),
      ),
    );
  }
}

final class _WorkView extends StatelessWidget {
  const _WorkView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          final bloc = context.read<WorkBloc>()
            ..add(const WorkRefreshRequested());
          await bloc.stream.first;
        },
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WorkOwner(),
              _WorkTitle(),
              _WorkCreatedTime(),
              _WorkAddress(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(height: 0),
              ),
              SizedBox(height: 16),
              _WorkDescription(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WorkOwner extends StatelessWidget {
  const _WorkOwner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.work != current.work,
      builder: (context, state) {
        if (state.status.isLoading) {
          return const ListTile(
            leading: Icon(Icons.person_rounded),
            title: Text('Author'),
            subtitle: Skeletonizer(
              child: Bone.text(words: 2),
            ),
          );
        }
        return ListTile(
          leading: const Icon(Icons.person_rounded),
          title: const Text('Author'),
          subtitle: Text(
            state.work.match(() => 'No author specified.', (t) => t.ownerName),
          ),
        );
      },
    );
  }
}

final class _WorkCreatedTime extends StatelessWidget {
  const _WorkCreatedTime();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.work != current.work,
      builder: (context, state) {
        if (state.status.isLoading) {
          return const ListTile(
            leading: Icon(Icons.access_time_filled_rounded),
            title: Skeletonizer(
              child: Bone.text(words: 4),
            ),
          );
        }
        return ListTile(
          leading: const Icon(Icons.access_time_filled_rounded),
          title: Text(
            state.work.match(
              () => 'No time specified.',
              (t) {
                final format = Jiffy.parseFromDateTime(t.createdAt).fromNow();
                return '${format[0].toUpperCase()}${format.substring(1)}';
              },
            ),
          ),
        );
      },
    );
  }
}

final class _WorkTitle extends StatelessWidget {
  const _WorkTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.work != current.work,
      builder: (context, state) {
        if (state.status.isLoading) {
          return const ListTile(
            leading: Icon(Icons.work_rounded),
            title: Skeletonizer(
              child: Bone.text(words: 6),
            ),
          );
        }
        return ListTile(
          leading: const Icon(Icons.work_rounded),
          title: Text(
            state.work.match(() => 'No title specified.', (t) => t.title),
          ),
        );
      },
    );
  }
}

final class _WorkAddress extends StatelessWidget {
  const _WorkAddress();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.work != current.work,
      builder: (context, state) {
        if (state.status.isLoading) {
          return const ListTile(
            leading: Icon(Icons.pin_drop_rounded),
            title: Skeletonizer(
              child: Bone.text(words: 12),
            ),
          );
        }
        return ListTile(
          leading: const Icon(Icons.pin_drop_rounded),
          title: Text(
            state.work.match(() => 'No address specified.', (t) => t.address),
          ),
        );
      },
    );
  }
}

final class _WorkDescription extends StatelessWidget {
  const _WorkDescription();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.work != current.work,
      builder: (context, state) {
        if (state.status.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Skeletonizer(
                  justifyMultiLineText: false,
                  child: Bone.multiText(lines: 20),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.work
                    .flatMap((t) => t.description)
                    .match(() => 'No description specified.', (t) => t),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _WorkAppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkBloc, WorkState>(
      bloc: context.read<WorkBloc>(),
      builder: (context, state) {
        if (state.status.isLoading) {
          return const Skeletonizer(
            child: Bone.text(words: 4),
          );
        }
        return ThemedAppBarTitle(
          state.work.match(() => '', (work) => work.title),
        );
      },
    );
  }
}

final class _WorkFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      icon: const Icon(Icons.create_rounded),
      label: const Text('Apply Now'),
    );
  }
}
