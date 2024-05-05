import 'package:equatable/equatable.dart';

final class UiError extends Equatable {
  UiError({required this.message, this.timestamp = 0});
  factory UiError.now({required String message}) => UiError(
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

  final String message;
  final int timestamp;

  UiError copyWith({String? message, int? timestamp}) => UiError(
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
      );

  @override
  List<Object?> get props => [message, timestamp];
}
