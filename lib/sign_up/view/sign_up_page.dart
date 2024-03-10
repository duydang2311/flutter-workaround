import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_up/bloc/sign_up_bloc.dart';
import 'package:workaround/sign_up/models/models.dart';
import 'package:workaround/theme/widgets/themed_app_bar.dart';

final class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: ThemedAppBar(title: l10n.signUpTitle),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) => SignUpBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          ),
          child: const _SignUpView(),
        ),
      ),
    );
  }
}

final class _SignUpView extends StatelessWidget {
  const _SignUpView();

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.submission.error != null) {
          _error(context, state.submission.error!);
        }
      },
      listenWhen: (previous, current) =>
          previous.submission != current.submission,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.brandName,
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.signUpHeading,
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              const _EmailInput(),
              const SizedBox(height: 16),
              const _PasswordInput(),
              const SizedBox(height: 16),
              const _ConfirmPasswordInput(),
              const SizedBox(height: 32),
              const SizedBox(
                width: double.infinity,
                child: _SubmitButton(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpView_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email: email)),
          decoration: InputDecoration(
            labelText: l10n.signUpEmailLabel,
            hintText: l10n.signUpEmailHint,
            errorText: state.email.displayError?.getMessage(context),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpView_passwordInput_textField'),
          onChanged: (password) => context
              .read<SignUpBloc>()
              .add(SignUpPasswordChanged(password: password)),
          decoration: InputDecoration(
            labelText: l10n.signUpPasswordLabel,
            hintText: l10n.signUpPasswordHint,
            errorText: state.password.displayError?.getMessage(context),
          ),
          obscureText: true,
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpView_confirmPasswordInput_textField'),
          onChanged: (confirmPassword) => context.read<SignUpBloc>().add(
                SignUpConfirmPasswordChanged(confirmPassword: confirmPassword),
              ),
          decoration: InputDecoration(
            labelText: l10n.signUpConfirmPasswordLabel,
            hintText: l10n.signUpConfirmPasswordHint,
            errorText: state.confirmPassword.displayError?.getMessage(context),
          ),
          obscureText: true,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.submission != current.submission ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.isValid || state.submission.status.isInProgress
              ? null
              : () {
                  context.read<SignUpBloc>().add(const SignUpSubmitted());
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
                ? Container(
                    padding: const EdgeInsets.all(2),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  )
                : Text(
                    l10n.signUpSubmit,
                  ),
          ),
        );
      },
    );
  }
}
