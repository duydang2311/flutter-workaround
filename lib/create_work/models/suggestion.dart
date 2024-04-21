import 'package:equatable/equatable.dart';

final class Suggestion extends Equatable {
  const Suggestion({
    required this.description,
    required this.placeId,
    required this.structuredFormat,
  });

  factory Suggestion.fromMap(Map<String, dynamic> map) {
    return Suggestion(
      description: map['description'] as String,
      placeId: map['place_id'] as String,
      structuredFormat: StructuredFormat.fromMap(
        map['structured_formatting'] as Map<String, dynamic>,
      ),
    );
  }

  final String description;
  final String placeId;
  final StructuredFormat structuredFormat;

  @override
  List<Object?> get props => [description, placeId, structuredFormat];
}

final class StructuredFormat extends Equatable {
  const StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromMap(Map<String, dynamic> map) {
    return StructuredFormat(
      mainText: map['main_text'] as String,
      secondaryText: map['secondary_text'] as String,
    );
  }

  final String mainText;
  final String secondaryText;

  @override
  List<Object?> get props => [mainText, secondaryText];
}
