# todo_task

Flutter 3.24.0
Dart 3.5.0

# Todo App
A simple and intuitive task management app built with Flutter. The app allows users to add, edit, delete, and mark tasks as completed. It supports filtering by date, category, and search queries.

# Features
1) Task Management :
     Add new tasks with a title, description, category, and due date.
     Edit or delete existing tasks.
     Mark tasks as completed with animations.

2) Filtering and Sorting :
     Filter tasks by category (e.g., Work, Personal, Shopping).
     Filter tasks by due date.
     Search tasks by title or description.

3) Persistence :
Data is stored locally using Hive (for mobile) and SQLite (for web).

4) Animations :
Smooth animations when marking tasks as completed.

5) Responsive Design :
     Works seamlessly on both mobile and web platforms.
     Tech Stack

6) Flutter : UI framework for building cross-platform apps.
7) Riverpod : State management for managing app state.
8) Hive : Local storage for mobile platforms.
9) QLite (sqflite_common_ffi_web) : Local storage for web platforms.
10) Animations : Built-in Flutter animations for task completion.

# Folder Structure
lib/
├── models/          # Data models (e.g., Todo)
├── providers/       # State management using Riverpod
├── repositories/    # Data persistence logic (Hive and SQLite)
├── service/         # Notification service
├── views/           # Screens (e.g., HomeScreen, AddTaskScreen)
└── widgets/         # Reusable widgets (e.g., TaskListTile)


# Installation
1) Clone the Repository :
    git clone https://github.com/your-repo/todo-app.git
    cd todo-app

2) Install Dependencies :
   flutter pub get

3) Run the App :
   For Mobile:
     flutter run

4) For Web:
   flutter run -d chrome

5) Build for Production :
   For Mobile:
     flutter build apk

6) For Web:    
   flutter build web