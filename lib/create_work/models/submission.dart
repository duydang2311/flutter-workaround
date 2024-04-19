import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

final class Submission extends Equatable {
  const Submission({required this.status, this.errorMessage});

  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
