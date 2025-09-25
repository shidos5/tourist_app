class Trip {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
