import 'package:equatable/equatable.dart';

sealed class SubmissionError extends Equatable {}

final class SubmissionErrorUnknown extends SubmissionError {
  SubmissionErrorUnknown({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  List<Object?> get props => [statusCode, message];
}
