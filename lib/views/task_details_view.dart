import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/model/task_model.dart';

class TaskDetailsView extends ConsumerWidget {
  final Task? task;

  const TaskDetailsView({this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task?.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Description: ${task?.description}'),
            SizedBox(height: 8),
            Text('Status: ${task!.isCompleted ? "Completed" : "Pending"}'),
            SizedBox(height: 8),
            Text('Created At: ${task?.createdAt.toString()}'),
          ],
        ),
      ),
    );
  }
}