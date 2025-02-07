class Todo {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final String category;
  final DateTime dueDate; // Add this field

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.dueDate, // Required field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'dueDate': dueDate.toIso8601String(), // Store as ISO string
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      category: map['category'] ?? 'Uncategorized',
      dueDate: DateTime.parse(map['dueDate']), // Parse from ISO string
    );
  }
}