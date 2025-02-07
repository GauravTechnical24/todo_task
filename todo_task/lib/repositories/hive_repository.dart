import 'package:hive_flutter/adapters.dart';
import 'package:todo_task/models/task.dart';

class HiveRepository {
  static const String boxName = 'todoBox';

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>(boxName);
  }

  // Access the Hive box
  Box<Todo> get box => Hive.box<Todo>(boxName);

  // Add a new task
  Future<void> addTodo(Todo todo) async {
    await box.put(todo.id, todo);
  }

  // Update an existing task
  Future<void> updateTodo(Todo todo) async {
    await box.put(todo.id, todo);
  }

  // Delete a task
  Future<void> deleteTodo(String id) async {
    await box.delete(id);
  }

  // Retrieve all tasks
  List<Todo> getAllTodos() {
    return box.values.toList();
  }

  // Migrate existing tasks to include new fields (e.g., category and dueDate)
  Future<void> migrateTodos() async {
    final todos = box.values.toList();

    for (final todo in todos) {
      // Check if the task has missing or null fields
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        category: todo.category.isEmpty ? 'Uncategorized' : todo.category, // Set default category
        dueDate: todo.dueDate, // Set default due date if missing
      );

      // Save the updated task back to Hive
      await box.put(todo.id, updatedTodo);
    }
  }
}

// Hive TypeAdapter for the Todo model
class TodoAdapter extends TypeAdapter<Todo> {
  @override
  int get typeId => 0;

  @override
  Todo read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return Todo.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.writeMap(obj.toMap());
  }
}