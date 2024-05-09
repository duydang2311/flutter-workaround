import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

base class GenericError extends Equatable {
  const GenericError({required this.message, this.code = ''});
  const GenericError.unknown() : this(message: 'Unknown error');

  factory GenericError.fromException(Exception exception, {String? code}) =>
      GenericError(message: exception.toString(), code: code ?? '');
  factory GenericError.fromAuthException(
    AuthException exception, {
    String? code,
  }) =>
      GenericError(
        message: exception.toString(),
        code: code ?? exception.statusCode ?? '',
      );

  final String code;
  final String message;

  String get formatted => switch (code) {
        final _ when code.isEmpty => "$message (code: '-')",
        _ => "$message (code: '$code')",
      };

  @override
  List<Object> get props => [code, message];
}
