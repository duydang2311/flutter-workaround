part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    required this.email,
    this.submission =
        const FormSubmissionState(status: FormzSubmissionStatus.initial),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  final FormSubmissionState submission;
  final Email email;
  final Password password;
  final bool isValid;

  SignInState copyWith({
    FormSubmissionState? submission,
    Email? email,
    Password? password,
    bool? isValid,
  }) =>
      SignInState(
        submission: submission ?? this.submission,
        email: email ?? this.email,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid,
      );

  @override
  List<Object> get props => [submission, email, password];
}

final class FormSubmissionState extends Equatable {
  const FormSubmissionState({required this.status, this.errorMessage});

  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
