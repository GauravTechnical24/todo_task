import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/task_provider.dart';
import './task_list_item.dart';
import '../views/add_edit_task_view.dart';

class TaskListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider).tasks;

    // Separate tasks into pending and completed
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    // Check if there are no tasks at all
    if (tasks.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            _buildTaskCountBadge('Total: ${tasks.length}'),
            const SizedBox(width: 8),
            _buildTaskCountBadge('Pending: ${pendingTasks.length}'),
            const SizedBox(width: 8),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(
                'No tasks available',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildTaskCountBadge('Total: ${tasks.length}'),
          const SizedBox(width: 8),
          _buildTaskCountBadge('Pending: ${pendingTasks.length}'),
          const SizedBox(width: 8),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Pending Tasks Section
          _buildSectionHeader('Pending Tasks', context),
          if (pendingTasks.isEmpty)
            _buildEmptyState('No pending tasks.', context)
          else
            ...pendingTasks.map((task) => TaskListItem(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskView(task: task),
                      ),
                    );
                  },
                  onDelete: () async {
                    await ref.read(taskProvider).deleteTask(task.id!);
                  },
                )),
          // Completed Tasks Section
          const SizedBox(height: 24), // Add spacing between sections
          _buildSectionHeader('Completed Tasks', context),
          if (completedTasks.isEmpty)
            _buildEmptyState('No completed tasks.', context)
          else
            ...completedTasks.map((task) => TaskListItem(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskView(task: task),
                      ),
                    );
                  },
                  onDelete: () async {
                    await ref.read(taskProvider).deleteTask(task.id!);
                  },
                )),
        ],
      ),
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String title, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:
              isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Helper method to display an empty state message
  Widget _buildEmptyState(String message, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
        ),
      ),
    );
  }

  // Helper method to build task count badges in the app bar
  Widget _buildTaskCountBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
