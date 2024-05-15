import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:workaround/edit_dob_input/bloc/edit_dob_input_bloc.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_up/models/models.dart';
import 'package:workaround/theme/theme.dart';
import 'package:intl/intl.dart'; 

final class EditDobInputPage extends StatelessWidget {
  const EditDobInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: ThemedAppBarTitle('Edit Basic birthday'),
      ),
      body: BlocProvider(
        create: (context) => EditDobInputBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        ),
        child: const _EditDobInputView(),
      ),
    );
  }
}

class _EditDobInputView extends StatelessWidget {
  const _EditDobInputView();

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
    return BlocListener<EditDobInputBloc, EditDobInputState>(
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
                      'Birthday',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: const _InputDob(),
                  ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      context.read<EditDobInputBloc>().add(EditDobInputChange(picked));
    }
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
    return BlocBuilder<EditDobInputBloc, EditDobInputState>(
      buildWhen: (previous, current) =>
          previous.submission != current.submission ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return MaterialButton(
          color: theme.colorScheme.primary,
          onPressed: !state.isValid || state.submission.status.isInProgress
              ? null
              : () {
                print("Asd");
            context.read<EditDobInputBloc>().add(const EditDobInputSubmitted());
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

class _InputDob extends StatelessWidget {
  const _InputDob({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDobInputBloc, EditDobInputState>(
      builder: (context, state) {
        final dob = state.dob.value;
        final formattedDate = dob != null ? DateFormat('yyyy-MM-dd').format(dob) : '';

        return InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Select your birthday',
            hintText: 'Select your birthday',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          child: TextFormField(
            key: const Key('signInView_emailInput_textField'),
            onChanged: (date) {},
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            enabled: false,
            controller: TextEditingController(text: formattedDate),
          ),
        );
      },
    );
  }
}
