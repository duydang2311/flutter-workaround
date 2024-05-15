import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:workaround/home/bloc/search_bloc.dart';
import 'package:workaround/home/home.dart';
import 'package:workaround/theme/theme.dart';

final class HomeSearch extends SearchDelegate<Option<SearchWork>> {
  HomeSearch({required this.bloc});

  final Bloc<SearchEvent, SearchState> bloc;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = '';
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        close(context, const Option.none());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bloc.add(SearchChanged(query));
    return BlocBuilder<Bloc<SearchEvent, SearchState>, SearchState>(
      bloc: bloc,
      builder: (context, state) => Skeletonizer(
        enabled: state.isLoading,
        child: ListView.separated(
          itemCount: state.works.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.work_rounded),
            title: Text(state.works[index].title),
            subtitle: Text(state.works[index].address),
            onTap: () {
              close(context, Option.of(state.works[index]));
            },
          ),
          separatorBuilder: (_, __) => const Divider(height: 0),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bloc.add(SearchChanged(query));
    return BlocBuilder<Bloc<SearchEvent, SearchState>, SearchState>(
      bloc: bloc,
      builder: (context, state) => AnimatedOpacity(
        opacity: state.isLoading ? 0.2 : 1,
        duration: Durations.long2,
        child: ListView.separated(
          itemCount: state.works.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.work_rounded),
            title: Text(state.works[index].title),
            subtitle: Text(state.works[index].address),
            onTap: () {
              close(context, Option.of(state.works[index]));
            },
          ),
          separatorBuilder: (_, __) => const Divider(height: 0),
        ),
      ),
    );
  }
}
