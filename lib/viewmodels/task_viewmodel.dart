import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/model/task_model.dart';
import 'package:todo_task/services/database_service.dart';
import '../repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final Ref ref; // Replace Reader with Ref
  late final TaskRepository _taskRepository;

  TaskViewModel(this.ref) {
    _taskRepository = ref.read(taskRepositoryProvider); // Use ref.read instead of _read
    fetchTasks();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _taskRepository.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    fetchTasks();
  }
}

// Provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(DatabaseService());
});