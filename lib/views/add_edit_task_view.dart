import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../provider/task_provider.dart';

class AddEditTaskView extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskView({this.task});

  @override
  ConsumerState<AddEditTaskView> createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends ConsumerState<AddEditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.primary, // Dynamic primary color
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[500],
                  ),
                ),
                onChanged: (value) => _title = value,
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                initialValue: _description,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[500],
                  ),
                ),
                onChanged: (value) => _description = value,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Completed Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) => setState(() => _isCompleted = value!),
                    activeColor:
                        theme.colorScheme.primary, // Dynamic primary color
                  ),
                  Text(
                    'Mark as Completed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      theme.colorScheme.primary, // Dynamic primary color
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        isCompleted: _isCompleted,
        createdAt: DateTime.now(),
      );

      if (widget.task == null) {
        ref.read(taskProvider).addTask(newTask);
      } else {
        ref.read(taskProvider).updateTask(newTask);
      }

      Navigator.pop(context);
    }
  }
}
