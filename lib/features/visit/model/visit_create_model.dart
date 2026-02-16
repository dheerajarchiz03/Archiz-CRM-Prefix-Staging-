class VisitCreateModel {
  final String client;
  final String name;
  final String department;
  final String userId;
  final String contactId;
  final String? priority;
  final String? service;
  final String? description;
  final String? visitDate;
  final String? status;

  VisitCreateModel({
    required this.client,
    required this.name,
    required this.department,
    required this.userId,
    required this.contactId,
    this.priority,
    this.service,
    this.description,
    this.visitDate,
    this.status,
  });
}
