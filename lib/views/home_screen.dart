import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_task/provider/user_preferences_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/task_list_view.dart';
import '../views/add_edit_task_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(userPreferencesProvider).themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.light_mode),
            onPressed: () {
              ref.read(userPreferencesProvider).saveThemeMode(ThemeMode.light);
            },
          ),
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: () {
              ref.read(userPreferencesProvider).saveThemeMode(ThemeMode.dark);
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: MobileHomeView(),
        tablet: TabletHomeView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditTaskView())),
        child: Icon(Icons.add),
      ),
    );
  }
}

class MobileHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TaskListView();
  }
}

class TabletHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TaskListView()),
        Expanded(child: Center(child: Text('Task Details'))),
      ],
    );
  }
}