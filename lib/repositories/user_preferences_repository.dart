import 'package:hive/hive.dart';
import 'package:todo_task/model/user_preferences_model.dart';

class UserPreferencesRepository {
  final Box _box;

  UserPreferencesRepository(this._box);

  UserPreferences getPreferences() {
    return UserPreferences.fromMap(_box.get('preferences', defaultValue: UserPreferences().toMap()));
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    await _box.put('preferences', preferences.toMap());
  }
}