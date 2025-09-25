class Todo {
  final String id;
  final String userId;
  final String tripId;
  final String task;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.task,
    this.isCompleted = false,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['user_id'],
      tripId: map['trip_id'],
      task: map['task'],
      isCompleted: map['is_completed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'trip_id': tripId,
      'task': task,
      'is_completed': isCompleted,
    };
  }
}
