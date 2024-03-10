import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_in/sign_in.dart';
import 'package:workaround/theme/widgets/themed_app_bar.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: ThemedAppBar(title: l10n.signInTitle),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (context) => SignInBloc(
            buildContext: context,
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          ),
          child: const _SignInView(),
        ),
      ),
    );
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) =>
          previous.submission != current.submission,
      listener: (context, state) {
        if (state.submission.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.submission.errorMessage!),
              ),
            );
        }
      },
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
              const SizedBox(height: 16),
              const SizedBox(
                width: double.infinity,
                child: _SignInWithGoogleButton(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.signInNoAccount),
                    TextButton(
                      child: Text(l10n.signInSignUp),
                      onPressed: () {
                        context.push('/sign-up');
                      },
                    ),
                  ],
                ),
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
          previous.submission != current.submission ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: !state.isValid || state.submission.status.isInProgress
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
            child: state.submission.status.isInProgress
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

class _SignInWithGoogleButton extends StatelessWidget {
  const _SignInWithGoogleButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) =>
          previous.googleSignInStatus != current.googleSignInStatus,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.googleSignInStatus == GoogleSignInStatus.pending
              ? null
              : () {
                  context
                      .read<SignInBloc>()
                      .add(const SignInWithGoogleRequested());
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
            child: state.googleSignInStatus == GoogleSignInStatus.pending
                ? Container(
                    padding: const EdgeInsets.all(2),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(),
                  )
                : Text(
                    l10n.signInWithGoogle,
                  ),
          ),
        );
      },
    );
  }
}
