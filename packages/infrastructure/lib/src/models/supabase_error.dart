import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract base class SupabaseError extends Equatable {
  const SupabaseError({required this.statusCode, required this.message});
  const SupabaseError.unknown()
      : statusCode = 0,
        message = 'Unknown error';
  SupabaseError.fromException(AuthException authException)
      : statusCode = authException.statusCode == null
            ? 0
            : int.tryParse(authException.statusCode!) ?? 0,
        message = authException.message;

  final int statusCode;
  final String message;

  @override
  List<Object> get props => [statusCode, message];
}
