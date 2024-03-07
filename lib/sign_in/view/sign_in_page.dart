import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_in/sign_in.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) => SignInBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          ),
          child: const SignInView(),
        ),
      ),
    );
  }
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Sign in failed.')));
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.brandName,
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.signInHeading,
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              const _EmailInput(),
              const SizedBox(height: 16),
              const _PasswordInput(),
              const SizedBox(height: 32),
              const SizedBox(
                width: double.infinity,
                child: _SubmitButton(),
              ),
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
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signInView_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignInBloc>().add(SignInEmailChanged(email)),
          decoration: InputDecoration(
            labelText: l10n.signInEmailLabel,
            hintText: l10n.signInEmailHint,
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
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signInView_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignInBloc>().add(SignInPasswordChanged(password)),
          decoration: InputDecoration(
            labelText: l10n.signInPasswordLabel,
            hintText: l10n.signInPasswordHint,
            errorText: state.password.displayError?.getMessage(context),
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
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.isValid || state.status.isInProgress
              ? null
              : () {
                  context.read<SignInBloc>().add(const SignInSubmitted());
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
            child: state.status.isInProgress
                ? Container(
                    padding: const EdgeInsets.all(2),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  )
                : Text(
                    l10n.signInSubmit,
                  ),
          ),
        );
      },
    );
  }
}
