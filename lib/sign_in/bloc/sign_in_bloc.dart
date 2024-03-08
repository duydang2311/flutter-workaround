import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_in/models/models.dart';
import 'package:workaround/sign_in/sign_in.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required BuildContext buildContext,
    required AuthenticationRepository authenticationRepository,
  })  : _buildContext = buildContext,
        _authenticationRepository = authenticationRepository,
        super(SignInState(email: Email.pure())) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSubmitted);
  }

  final BuildContext _buildContext;
  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
          [
            email,
            state.password,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate(
          [
            state.email,
            password,
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (!state.isValid) return;

    emit(
      state.copyWith(
        submission:
            const FormSubmissionState(status: FormzSubmissionStatus.inProgress),
      ),
    );
    await _authenticationRepository
        .signInWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    )
        .match(
      (error) {
        emit(
          state.copyWith(
            submission: FormSubmissionState(
              status: FormzSubmissionStatus.failure,
              errorMessage: _errorMessage(error),
            ),
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            submission: const FormSubmissionState(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    ).run();
  }

  String _errorMessage(AuthenticationError error) {
    final l10n = _buildContext.l10n;
    return switch (error.statusCode) {
      400 => l10n.signInSubmitErrorInvalidCredentials,
      _ => l10n.signInSubmitErrorUnknown(error.statusCode),
    };
  }
}
