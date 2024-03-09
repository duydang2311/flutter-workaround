part of 'sign_up_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    required this.email,
    this.submission = const Submission(status: FormzSubmissionStatus.initial),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.isValid = false,
  });

  final Submission submission;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final bool isValid;

  SignUpState copyWith({
    Submission? submission,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isValid,
  }) =>
      SignUpState(
        submission: submission ?? this.submission,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props =>
      [submission, email, password, confirmPassword, isValid];
}
