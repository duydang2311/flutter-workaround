import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/edit_gender_input/bloc/edit_gender_input_bloc.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_up/models/models.dart';
import 'package:workaround/theme/theme.dart';

final class EditGenderInputPage extends StatelessWidget {
  const EditGenderInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: ThemedAppBarTitle('Edit Gender'),
      ),
      body: BlocProvider(
        create: (context) => EditGenderInputBloc(
            profileRepository: RepositoryProvider.of(context)),
        child: const _EditGenderInputView(),
      ),
    );
  }
}

final class _EditGenderInputView extends StatelessWidget {
  const _EditGenderInputView();

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
    return BlocListener<EditGenderInputBloc, EditGenderInputState>(
      listener: (context, state) {
        print(state.submission.error);
        if (state.submission.error != null) {
          _error(context, state.submission.error!);
        }
        if (state.submission.status.isSuccess) {
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
                      'Edit gender',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const GenderInput(),
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
                      child: _SubmitButton(theme: theme),
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGenderInputBloc, EditGenderInputState>(
      builder: (context, state) {
        return MaterialButton(
          color: theme.colorScheme.primary,
          onPressed: !state.isValid || state.submission.status.isInProgress
              ? null
              : () {
                  context
                      .read<EditGenderInputBloc>()
                      .add(const EditGenderInputSubmitted());
                },
          child: Text(
            'Save',
            style: theme.textTheme.displayMedium!.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}

class GenderInput extends StatelessWidget {
  const GenderInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditGenderInputBloc, EditGenderInputState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InputDecorator(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  key: const Key('gender_dropdown'),
                  value: state.gender.value,
                  onChanged: (String? newValue) {
                    context
                        .read<EditGenderInputBloc>()
                        .add(EditGenderInputChange(newValue ?? ''));
                  },
                  items: <String>['', 'Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
