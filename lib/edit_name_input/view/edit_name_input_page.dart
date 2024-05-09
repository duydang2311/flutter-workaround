import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/edit_name_input/bloc/edit_name_bloc.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_up/models/submission_error.dart';
import 'package:workaround/theme/theme.dart';

class EditNameInputPage extends StatelessWidget {
  const EditNameInputPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: ThemedAppBarTitle('Edit Display Name'),
      ),
      body: BlocProvider(
        create: (context) =>
            EditNameBloc(profileRepository: RepositoryProvider.of(context)),
        child: const _EditNameInputView(),
      ),
    );
  }
}

class _EditNameInputView extends StatelessWidget {
  const _EditNameInputView();

  void _error(BuildContext context, SubmissionError error) {
    final l10n = context.l10n;
    
    final message = switch (error) {
      final SubmissionErrorUnknown unknown =>
        l10n.signUpSubmitErrorUnknown(unknown.code),
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
  void _sucess(BuildContext context) {
    final l10n = context.l10n;
    
    const message = 'Success update';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(message),
        ),
      );

      context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return BlocListener<EditNameBloc, EditNameState>(
      listener: (context, state) {
        if (state.submission.error != null) {
          _error(context, state.submission.error!);
        } 
        if(state.submission.status.isSuccess) {
          _sucess(context);
        }
      },
      listenWhen: (previous, current) =>
          previous.submission != current.submission,
      child: SizedBox(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: const Text(
                      'Edit display name on your profile',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _NameInput(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _SubmissionButton(theme: theme),
                    ),
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

class _SubmissionButton extends StatelessWidget {
  const _SubmissionButton({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNameBloc, EditNameState>(
      buildWhen: (previous, current) =>
          previous.submission != current.submission ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return MaterialButton(
          color: theme.colorScheme.primary,
          onPressed: !state.isValid || state.submission.status.isInProgress
              ? null
              : () {
                  context.read<EditNameBloc>().add(const EditNameSubmitted());
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
                : Text(
                    'Save',
                    style: theme.textTheme.displayMedium!.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNameBloc, EditNameState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('signInView_emailInput_textField'),
          onChanged: (name) {
            context.read<EditNameBloc>().add(EditNameChange(name));
          },
          decoration: const InputDecoration(
            labelText: 'Enter ur name',
            hintText: 'Enter ur name',
          ),
        );
      },
    );
  }
}
