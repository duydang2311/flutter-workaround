import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignUpState(email: Email.pure())) {
    on<SignUpEmailChanged>(_handleEmailChanged);
    on<SignUpPasswordChanged>(_handlePasswordChanged);
    on<SignUpConfirmPasswordChanged>(_handleConfirmPasswordChanged);
    on<SignUpSubmitted>(_handleSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _handleEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
          [
            state.confirmPassword,
            email,
            state.password,
          ],
        ),
      ),
    );
  }

  void _handlePasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate(
          [
            state.confirmPassword,
            state.email,
            password,
          ],
        ),
      ),
    );
  }

  void _handleConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
      value: event.confirmPassword,
      original: state.password,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate(
          [
            confirmPassword,
            state.email,
            state.password,
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      state.copyWith(
        submission: const Submission(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );
    await _authenticationRepository
        .signUpWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    )
        .match((error) {
      emit(
        state.copyWith(
          submission: Submission(
            status: FormzSubmissionStatus.failure,
            error: _submissionError(error),
          ),
        ),
      );
    }, (_) {
      emit(
        state.copyWith(
          submission: const Submission(status: FormzSubmissionStatus.success),
        ),
      );
    }).run();
  }

  SubmissionError _submissionError(AuthenticationError authError) {
    switch (authError.code) {
      case '400':
        return SubmissionErrorUnknown(
          code: authError.code,
          message: authError.message,
        );
      default:
        return SubmissionErrorUnknown(
          code: authError.code,
          message: authError.message,
        );
    }
  }
}
