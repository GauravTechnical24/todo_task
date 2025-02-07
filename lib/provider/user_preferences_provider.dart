import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/user_preferences_viewmodel.dart';

final userPreferencesProvider =
    ChangeNotifierProvider<UserPreferencesViewModel>((ref) {
  return UserPreferencesViewModel(ref);
});
