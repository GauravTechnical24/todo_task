import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/models/task.dart';
import '../repositories/hive_repository.dart';
import '../repositories/sqlite_repository.dart';

class TodoViewModel {
  final HiveRepository _hiveRepo = HiveRepository();
  final SQLiteRepository _sqliteRepo = SQLiteRepository();

  Future<void> init() async {
    if (!kIsWeb) {
      await _hiveRepo.init();
    }
  }

  // Fetch all todos from the database
  Future<List<Todo>> getAllTodos() async {
    if (kIsWeb) {
      return await _sqliteRepo.getAllTodos();
    } else {
      return _hiveRepo.getAllTodos();
    }
  }

  // Add a new todo to the database
  Future<void> addTodo(Todo todo) async {
    if (kIsWeb) {
      await _sqliteRepo.addTodo(todo);
    } else {
      await _hiveRepo.addTodo(todo);
    }
  }

  // Update an existing todo in the database
  Future<void> updateTodo(Todo todo) async {
    if (kIsWeb) {
      await _sqliteRepo.updateTodo(todo);
    } else {
      await _hiveRepo.updateTodo(todo);
    }
  }

  // Delete a todo from the database
  Future<void> deleteTodo(String id) async {
    if (kIsWeb) {
      await _sqliteRepo.deleteTodo(id);
    } else {
      await _hiveRepo.deleteTodo(id);
    }
  }
}

// Provider for TodoViewModel
final todoViewModelProvider = Provider<TodoViewModel>((ref) {
  return TodoViewModel();
});