import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../model/user_preferences_model.dart';
import '../services/hive_service.dart';

class UserPreferencesViewModel extends ChangeNotifier {
  final Ref ref; // Replace Reader with Ref

  UserPreferencesViewModel(this.ref) {
    _loadPreferences();
  }

  UserPreferences _preferences = HiveService.getUserPreferences();
  UserPreferences get preferences => _preferences;

  ThemeMode get themeMode => _preferences.themeMode;
  String get sortOption => _preferences.sortOption;

  void _loadPreferences() {
    _preferences = HiveService.getUserPreferences();
    notifyListeners();
  }

void saveThemeMode(ThemeMode mode) {
  _preferences = UserPreferences(themeMode: mode, sortOption: _preferences.sortOption);
  HiveService.saveUserPreferences(_preferences);
  notifyListeners();
}

  void saveSortOption(String option) {
    _preferences = UserPreferences(
      themeMode: _preferences.themeMode,
      sortOption: option,
    );
    HiveService.saveUserPreferences(_preferences);
    notifyListeners();
  }
}