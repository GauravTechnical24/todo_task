import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_task/model/user_preferences_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserPreferencesAdapter());
    await Hive.openBox<UserPreferences>('userPreferences');
  }

  static Box<UserPreferences> get box => Hive.box<UserPreferences>('userPreferences');

  static void saveUserPreferences(UserPreferences preferences) {
    box.put('preferences', preferences);
  }

  static UserPreferences getUserPreferences() {
    return box.get('preferences') ?? UserPreferences();
  }
}