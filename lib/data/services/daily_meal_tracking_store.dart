import 'package:shared_preferences/shared_preferences.dart';

abstract class DailyMealTrackingStore {
  Future<Set<String>> loadConsumedMealIds(String dayKey);

  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds);
}

class SharedPreferencesDailyMealTrackingStore
    implements DailyMealTrackingStore {
  const SharedPreferencesDailyMealTrackingStore();

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_keyFor(dayKey))?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds) async {
    final preferences = await SharedPreferences.getInstance();
    final sortedMealIds = mealIds.toList()..sort();
    await preferences.setStringList(_keyFor(dayKey), sortedMealIds);
  }

  String _keyFor(String dayKey) => 'daily_meal_tracking_$dayKey';
}

class MemoryDailyMealTrackingStore implements DailyMealTrackingStore {
  MemoryDailyMealTrackingStore({
    Map<String, Set<String>> initialConsumedMealIdsByDay = const {},
  }) : _consumedMealIdsByDay = initialConsumedMealIdsByDay.map(
         (dayKey, mealIds) => MapEntry(dayKey, mealIds.toSet()),
       );

  final Map<String, Set<String>> _consumedMealIdsByDay;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async {
    return _consumedMealIdsByDay[dayKey]?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds) async {
    _consumedMealIdsByDay[dayKey] = mealIds.toSet();
  }
}
