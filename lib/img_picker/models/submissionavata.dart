import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:workaround/sign_up/models/models.dart';

final class SubmissionUpdateAvata extends Equatable {
  const SubmissionUpdateAvata({required this.status, this.error});

  final FormzSubmissionStatus status;
  final SubmissionError? error;

  @override
  List<Object?> get props => [status, error];
}
