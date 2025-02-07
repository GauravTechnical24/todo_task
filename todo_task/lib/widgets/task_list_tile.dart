import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/models/task.dart';
import '../providers/todo_provider.dart';

class TaskListTile extends ConsumerStatefulWidget {
  final Todo todo;

  const TaskListTile({super.key, required this.todo});

  @override
  TaskListTileState createState() => TaskListTileState();
}

class TaskListTileState extends ConsumerState<TaskListTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addStatusListener((status) {
        // Remove the task from the provider after the animation completes
        if (status == AnimationStatus.completed && mounted) {
          ref.read(todoProvider.notifier).deleteTodo(widget.todo.id);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDarkMode
        ? [Colors.deepPurple.shade800, Colors.deepOrange.shade900]
        : [Colors.white, Colors.grey.shade200];

    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: 0.0,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Checkbox to toggle task completion status
                Checkbox(
                  value: widget.todo.isCompleted,
                  onChanged: (value) async {
                    final updatedTodo = Todo(
                      id: widget.todo.id,
                      title: widget.todo.title,
                      description: widget.todo.description,
                      isCompleted: value!, // Toggle the status
                      category: widget.todo.category,
                      dueDate: widget.todo.dueDate,
                    );

                    // Update the task in the provider
                    ref.read(todoProvider.notifier).updateTodo(updatedTodo);

                    // // Trigger the animation only when the task is marked as completed
                    // if (value) {
                    //   if (mounted) {
                    //     _controller.forward(); // Shrink the task
                    //   }
                    // } else {
                    //   // Reset the animation if the task is marked as pending
                    //   _controller.reset();
                    // }
                  },
                ),

                // Task details (title, description, and due date)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
                          color: widget.todo.isCompleted
                              ? Colors.grey
                              : isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.todo.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.todo.isCompleted
                              ? Colors.grey
                              : isDarkMode
                              ? Colors.white70
                              : Colors.grey[700],
                          decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${_formatDate(widget.todo.dueDate)}', // Display formatted due date
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.todo.isCompleted
                              ? Colors.grey
                              : isDarkMode
                              ? Colors.white70
                              : Colors.grey[700],
                          decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons (Edit and Delete)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: isDarkMode ? Colors.blue.shade300 : Colors.blue),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: widget.todo,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: isDarkMode ? Colors.red.shade300 : Colors.red),
                      onPressed: () {
                        ref.read(todoProvider.notifier).deleteTodo(widget.todo.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to format the due date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}