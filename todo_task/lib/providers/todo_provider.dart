import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/models/task.dart';
import '../repositories/hive_repository.dart';
import '../repositories/sqlite_repository.dart';

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  final HiveRepository hiveRepo = HiveRepository();
  final SQLiteRepository sqliteRepo = SQLiteRepository();

  TodoNotifier() : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    if (kIsWeb) {
      state = await sqliteRepo.getAllTodos();
    } else {
      await hiveRepo.init();
      state = hiveRepo.getAllTodos();
    }
  }

  Future<void> addTodo(Todo todo) async {
    if (kIsWeb) {
      await sqliteRepo.addTodo(todo);
    } else {
      await hiveRepo.addTodo(todo);
    }
    state = [...state, todo];
  }

  Future<void> updateTodo(Todo todo) async {
    if (kIsWeb) {
      await sqliteRepo.updateTodo(todo);
    } else {
      await hiveRepo.updateTodo(todo);
    }
    state = state.map((t) => t.id == todo.id ? todo : t).toList();
  }

  Future<void> deleteTodo(String id) async {
    if (kIsWeb) {
      await sqliteRepo.deleteTodo(id);
    } else {
      await hiveRepo.deleteTodo(id);
    }
    state = state.where((t) => t.id != id).toList();
  }
}