import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/models/task.dart';
import 'package:todo_task/providers/todo_provider.dart';


final searchProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  final query = ref.watch(searchProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  List<Todo> filteredTodos = todos;

  // Filter by search query
  if (query.isNotEmpty) {
    filteredTodos = filteredTodos.where((todo) {
      return todo.title.toLowerCase().contains(query) ||
          todo.description.toLowerCase().contains(query);
    }).toList();
  }

  // Filter by category
  if (selectedCategory != 'All') {
    filteredTodos = filteredTodos.where((todo) => todo.category == selectedCategory).toList();
  }

  // Filter by date
  if (selectedDate != null) {
    filteredTodos = filteredTodos.where((todo) {
      return todo.dueDate.year == selectedDate.year &&
          todo.dueDate.month == selectedDate.month &&
          todo.dueDate.day == selectedDate.day;
    }).toList();
  }

  return filteredTodos;
});