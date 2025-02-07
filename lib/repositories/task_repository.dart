import 'package:todo_task/model/task_model.dart';

import '../services/database_service.dart';

class TaskRepository {
  final DatabaseService _databaseService;

  TaskRepository(this._databaseService);

  Future<void> addTask(Task task) async {
    await _databaseService.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
  }

  Future<List<Task>> getTasks() async {
    return await _databaseService.getTasks();
  }
}