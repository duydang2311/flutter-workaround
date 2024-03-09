import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:workaround/sign_up/models/models.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState(email: Email.pure())) {
    on<SignUpEmailChanged>(_handleEmailChanged);
    on<SignUpPasswordChanged>(_handlePasswordChanged);
    on<SignUpConfirmPasswordChanged>(_handleConfirmPasswordChanged);
    on<SignUpSubmitted>(_handleSubmitted);
  }

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
    final confirmPassword = ConfirmPassword.dirty(event.confirmPassword);
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
  ) async {}
}
