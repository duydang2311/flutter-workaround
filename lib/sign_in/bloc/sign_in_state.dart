part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    required this.email,
    this.submission =
        const FormSubmissionState(status: FormzSubmissionStatus.initial),
    this.password = const Password.pure(),
    this.isValid = false,
    this.googleSignInStatus = GoogleSignInStatus.none,
  });

  final FormSubmissionState submission;
  final Email email;
  final Password password;
  final bool isValid;
  final GoogleSignInStatus googleSignInStatus;

  SignInState copyWith({
    FormSubmissionState? submission,
    Email? email,
    Password? password,
    bool? isValid,
    GoogleSignInStatus? googleSignInStatus,
  }) =>
      SignInState(
        submission: submission ?? this.submission,
        email: email ?? this.email,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid,
        googleSignInStatus: googleSignInStatus ?? this.googleSignInStatus,
      );

  @override
  List<Object> get props => [submission, email, password, googleSignInStatus];
}

final class FormSubmissionState extends Equatable {
  const FormSubmissionState({required this.status, this.errorMessage});

  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
