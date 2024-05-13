import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:work_repository/work_repository.dart';

final class Work extends Equatable {
  const Work({
    required this.id,
    required this.createdAt,
    required this.recruiterId,
    required this.title,
    required this.recruiterName,
    required this.address,
    required this.status,
    this.description = const Option.none(),
  });

  final String id;
  final DateTime createdAt;
  final String recruiterId;
  final String recruiterName;
  final String title;
  final String address;
  final WorkStatus status;
  final Option<String> description;

  Work copyWith({
    String? id,
    DateTime? createdAt,
    String? recruiterId,
    String? recruiterName,
    String? title,
    String? address,
    WorkStatus? status,
    Option<String>? description,
  }) =>
      Work(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        recruiterId: recruiterId ?? this.recruiterId,
        recruiterName: recruiterName ?? this.recruiterName,
        title: title ?? this.title,
        address: address ?? this.address,
        status: status ?? this.status,
        description: description ?? this.description,
      );

  @override
  List<Object> get props => [
        id,
        createdAt,
        recruiterId,
        recruiterName,
        title,
        address,
        status,
        description,
      ];
}
