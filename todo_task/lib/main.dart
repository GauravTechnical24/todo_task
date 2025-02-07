import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:todo_task/models/task.dart';
import 'views/home_screen.dart';
import 'views/add_task_screen.dart';
import 'views/edit_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SQLite for the web
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddTaskScreen(),
        '/edit': (context) => EditTaskScreen(todo: ModalRoute.of(context)!.settings.arguments as Todo),
      },
    );
  }
}

// Theme Provider
final themeProvider = StateProvider<bool>((ref) => false); // false = light mode, true = dark mode