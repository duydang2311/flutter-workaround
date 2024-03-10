import 'package:equatable/equatable.dart';

sealed class SubmissionError extends Equatable {}

final class SubmissionErrorUnknown extends SubmissionError {
  SubmissionErrorUnknown({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  @override
  List<Object?> get props => [code, message];
}
