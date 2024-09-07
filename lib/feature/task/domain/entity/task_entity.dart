class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isDone = false,
  });

  // Add this copyWith method
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
