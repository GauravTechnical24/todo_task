import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/models/task.dart';
import 'package:todo_task/providers/search_provider.dart';
import '../widgets/task_list_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodos = ref.watch(filteredTodosProvider);
    final categories = ['All', 'Work', 'Personal', 'Shopping', 'Other'];
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending (${filteredTodos.where((todo) => !todo.isCompleted).length})'),
              Tab(text: 'Completed (${filteredTodos.where((todo) => todo.isCompleted).length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  labelText: 'Search Tasks',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
              ),
            ),

            Row(children: [
              // Category Dropdown
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Filter by Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                    onChanged: (value) {
                      ref.read(selectedCategoryProvider.notifier).state = value!;
                    },
                  ),
                ),
              ),

              // Date Picker
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        ref.read(selectedDateProvider.notifier).state = picked;
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Filter by Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              selectedDate == null
                                  ? 'No date selected'
                                  : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],),


            const SizedBox(height: 15.0,),

            // TabBarView with filtered tasks
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskList(
                    filteredTodos.where((todo) => !todo.isCompleted).toList(),
                    'No pending tasks found.',
                  ),
                  _buildTaskList(
                    filteredTodos.where((todo) => todo.isCompleted).toList(),
                    'No completed tasks found.',
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Todo> todos, String emptyMessage) {
    if (todos.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => TaskListTile(todo: todos[index]),
    );
  }
}