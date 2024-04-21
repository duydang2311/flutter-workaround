import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/create_work/bloc/bottom_sheet_bloc.dart';
import 'package:workaround/create_work/create_work.dart';
import 'package:workaround/home_scaffold/home_scaffold.dart';
import 'package:workaround/theme/theme.dart';

part 'create_work_bottom_sheet.dart';

final class CreateWorkPage extends StatelessWidget {
  const CreateWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeScaffoldBloc>();
    bloc.add(
      HomeScaffoldChanged(
        scaffoldMap: {
          ...bloc.state.scaffoldMap,
          'create-work': const ScaffoldData(
            appBar: ThemedAppBar(
              title: ThemedAppBarTitle('Create work'),
            ),
          ),
        },
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateWorkBloc(
            client: RepositoryProvider.of<Client>(context),
            workRepository: RepositoryProvider.of<WorkRepository>(context),
            appUserRepository:
                RepositoryProvider.of<AppUserRepository>(context),
          )..add(const CreateWorkInitialized()),
        ),
        BlocProvider(
          create: (context) => BottomSheetBloc(
            RepositoryProvider.of<Client>(context),
          ),
        ),
      ],
      child: BlocListener<BottomSheetBloc, BottomSheetState>(
        listener: (context, state) {
          context
              .read<CreateWorkBloc>()
              .add(CreateWorkSuggestionSelected(suggestion: state.selected));
        },
        child: const _CreateWorkView(),
      ),
    );
  }
}

final class _CreateWorkView extends StatelessWidget {
  const _CreateWorkView();

  @override
  Widget build(BuildContext context) {
    return ThemedScaffoldBody(
      middle: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fill in the form to create a work.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const _LocationSearch(),
          const SizedBox(height: 16),
          const _TitleInput(),
          const SizedBox(height: 16),
          const _DescriptionInput(),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, child: _SubmitButton()),
        ],
      ),
    );
  }
}

class _LocationSearch extends StatefulWidget {
  const _LocationSearch();

  @override
  State<StatefulWidget> createState() => _LocationSearchState();
}

final class _LocationSearchState extends State<_LocationSearch> {
  _LocationSearchState();

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateWorkBloc, CreateWorkState>(
      listener: (context, state) {
        state.place.match(() {
          _controller.text = '';
        }, (place) {
          _controller.text = place.address;
          place.errorMessage.match(() {}, (errorMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
              ),
            );
          });
        });
        _controller.text =
            state.place.match(() => '', (place) => place.address);
      },
      listenWhen: (previous, current) => previous.place != current.place,
      buildWhen: (previous, current) => previous.place != current.place,
      builder: (context, state) {
        return TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Search for work address',
            suffixIcon: const Icon(Icons.search),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            errorText: state.place.toNullable()?.errorMessage.toNullable(),
          ),
          mouseCursor: SystemMouseCursors.click,
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (modalContext) =>
                  _BottomSheet.build(modalContext, context),
            );
          },
          readOnly: true,
          keyboardType: TextInputType.streetAddress,
        );
      },
    );
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateWorkBloc, CreateWorkState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context
              .read<CreateWorkBloc>()
              .add(CreateWorkTitleChanged(title: value)),
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: 'Enter work title',
            errorText: state.title.displayError?.getMessage(context),
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateWorkBloc, CreateWorkState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextField(
          onChanged: (value) => context
              .read<CreateWorkBloc>()
              .add(CreateWorkDescriptionChanged(description: value)),
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            hintText: 'Enter work description',
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          keyboardType: TextInputType.multiline,
          minLines: 6,
          maxLines: 6,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateWorkBloc, CreateWorkState>(
      listenWhen: (previous, current) =>
          previous.submission != current.submission,
      listener: (context, state) {
        if (state.submission.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your work request has been created.'),
            ),
          );
        } else if (state.submission.status == FormzSubmissionStatus.failure &&
            (state.submission.errorMessage?.isNotEmpty ?? false)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submission.errorMessage!)),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.submission != current.submission ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.isValid || state.submission.status.isInProgress
              ? null
              : () {
                  context
                      .read<CreateWorkBloc>()
                      .add(const CreateWorkSubmitted());
                },
          child: AnimatedSwitcher(
            duration: Durations.medium2,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: state.submission.status.isInProgress
                ? const ThemedCircularProgressIndicator()
                : const Text('Create'),
          ),
        );
      },
    );
  }
}
