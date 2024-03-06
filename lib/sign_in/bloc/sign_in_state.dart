part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    required this.email,
    this.status = FormzSubmissionStatus.initial,
    this.password = const Password.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool isValid;

  SignInState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? isValid,
  }) =>
      SignInState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props => [status, email, password];
}
