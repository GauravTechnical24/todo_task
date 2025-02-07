import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_task/models/task.dart';


class SQLiteRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    if (kIsWeb) {
      // Use an in-memory database for the web
      path = inMemoryDatabasePath;
    } else {
      // Use the device's file system for mobile
      final directory = await getApplicationDocumentsDirectory();
      path = join(directory.path, 'todo.db');
    }

    return await openDatabase(
      path,
      version: 2, // Increment the version number to trigger migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add migration logic
    );
  }

  // Create the initial table schema
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        isCompleted INTEGER,
        category TEXT,
        dueDate TEXT
      )
    ''');
  }

  // Handle schema upgrades (e.g., adding the dueDate column)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Backup the old table
      await db.execute('ALTER TABLE todos RENAME TO todos_old');

      // Create the new table with the updated schema
      await db.execute('''
        CREATE TABLE todos (
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          isCompleted INTEGER,
          category TEXT,
          dueDate TEXT
        )
      ''');

      // Copy data from the old table to the new table
      await db.execute('''
        INSERT INTO todos (id, title, description, isCompleted, category, dueDate)
        SELECT id, title, description, isCompleted, category, '' FROM todos_old
      ''');

      // Drop the old table
      await db.execute('DROP TABLE todos_old');
    }
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final result = await db.query('todos');
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}