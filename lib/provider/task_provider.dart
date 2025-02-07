import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/task_viewmodel.dart';

final taskProvider = ChangeNotifierProvider<TaskViewModel>((ref) {
  return TaskViewModel(ref);
});