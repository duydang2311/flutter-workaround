final class WorkApplication {
  WorkApplication({
    this.id = '',
    this.workId = '',
    this.applicantId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String workId;
  final String applicantId;
}
