import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract base class SupabaseError extends Equatable {
  const SupabaseError({required this.message, this.code = '-'});
  const SupabaseError.unknown()
      : code = '-',
        message = 'Unknown error';
  SupabaseError.fromException(AuthException authException)
      : code = authException.statusCode ?? '-',
        message = authException.message;

  final String code;
  final String message;

  @override
  List<Object> get props => [code, message];
}
