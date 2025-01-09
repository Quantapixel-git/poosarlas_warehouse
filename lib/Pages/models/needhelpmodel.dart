class HelpRequest {
  final int userId;
  final String name;
  final String subject;
  final String description;
  final String createdAt;
  final String updatedAt;

  // Add other fields as needed

  HelpRequest({
    required this.userId,
    required this.name,
    required this.subject,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a HelpRequest object from a Map
  factory HelpRequest.fromMap(Map<String, dynamic> map) {
    return HelpRequest(
      userId:
          map['user_id'] is String ? int.parse(map['user_id']) : map['user_id'],
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? 'N/A',
      updatedAt: map['updated_at'] ?? 'N/A',
    );
  }
}
