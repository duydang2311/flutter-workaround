part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignUpConfirmPasswordChanged extends SignUpEvent {
  const SignUpConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;

  @override
  List<Object> get props => [confirmPassword];
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
