import 'dart:convert';

import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataStore {
  Future<UserProfile?> loadUserProfile();

  Future<void> saveUserProfile(UserProfile profile);

  Future<LocalMealPlan?> loadActiveMealPlan();

  Future<void> saveActiveMealPlan({
    required List<Meal> meals,
    required NutritionSummary summary,
  });

  Future<Set<String>> loadConsumedMealIds(String dayKey);

  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids);

  Future<List<ShoppingListItem>> loadShoppingList();

  Future<void> saveShoppingList(List<ShoppingListItem> items);
}

abstract class LocalStringStore {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);
}

class SharedPreferencesStringStore implements LocalStringStore {
  SharedPreferencesStringStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }
}

class LocalMealPlan {
  const LocalMealPlan({required this.meals, required this.summary});

  final List<Meal> meals;
  final NutritionSummary summary;
}

class SharedPreferencesLocalDataStore implements LocalDataStore {
  SharedPreferencesLocalDataStore({LocalStringStore? strings})
    : _strings = strings ?? SharedPreferencesStringStore();

  static const userProfileKey = 'mealcrunchy.v1.user_profile';
  static const activeMealPlanKey = 'mealcrunchy.v1.active_meal_plan';
  static const shoppingListKey = 'mealcrunchy.v1.shopping_list';

  static String consumedMealIdsKey(String dayKey) {
    return 'mealcrunchy.v1.consumed_meal_ids.$dayKey';
  }

  final LocalStringStore _strings;

  @override
  Future<UserProfile?> loadUserProfile() {
    return _readObject(userProfileKey, UserProfile.fromJson);
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) {
    return _writeJson(userProfileKey, profile.toJson());
  }

  @override
  Future<LocalMealPlan?> loadActiveMealPlan() {
    return _readObject(activeMealPlanKey, (json) {
      final meals = _readJsonList(json['meals'], Meal.fromJson);
      final summaryJson = _asJsonMap(json['summary']);

      if (meals == null || summaryJson == null) {
        throw const FormatException('Invalid active meal plan payload.');
      }

      return LocalMealPlan(
        meals: meals,
        summary: NutritionSummary.fromJson(summaryJson),
      );
    });
  }

  @override
  Future<void> saveActiveMealPlan({
    required List<Meal> meals,
    required NutritionSummary summary,
  }) {
    return _writeJson(activeMealPlanKey, {
      'meals': meals.map((meal) => meal.toJson()).toList(growable: false),
      'summary': summary.toJson(),
    });
  }

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async {
    final ids = await _readObject<List<String>>(consumedMealIdsKey(dayKey), (
      json,
    ) {
      return _readStringList(json['ids']) ??
          (throw const FormatException('Invalid consumed meal ids payload.'));
    });

    return ids?.toSet() ?? <String>{};
  }

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) {
    final sortedIds = ids.toList()..sort();
    return _writeJson(consumedMealIdsKey(dayKey), {'ids': sortedIds});
  }

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    final payload = await _readRawJson(shoppingListKey);
    final items = _readJsonList(payload, ShoppingListItem.fromJson);
    return items ?? const <ShoppingListItem>[];
  }

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) {
    return _writeJson(
      shoppingListKey,
      items.map((item) => item.toJson()).toList(growable: false),
    );
  }

  Future<T?> _readObject<T>(
    String key,
    T Function(Map<String, Object?> json) parse,
  ) async {
    final payload = await _readRawJson(key);
    final json = _asJsonMap(payload);
    if (json == null) {
      return null;
    }

    try {
      return parse(json);
    } on Object {
      return null;
    }
  }

  Future<Object?> _readRawJson(String key) async {
    final value = await _strings.getString(key);
    if (value == null) {
      return null;
    }

    try {
      return jsonDecode(value);
    } on Object {
      return null;
    }
  }

  Future<void> _writeJson(String key, Object? value) {
    return _strings.setString(key, jsonEncode(value));
  }

  Map<String, Object?>? _asJsonMap(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }

    if (value is Map) {
      return value.cast<String, Object?>();
    }

    return null;
  }

  List<T>? _readJsonList<T>(
    Object? value,
    T Function(Map<String, Object?> json) parse,
  ) {
    if (value is! List) {
      return null;
    }

    try {
      return value.map(_asJsonMap).nonNulls.map(parse).toList(growable: false);
    } on Object {
      return null;
    }
  }

  List<String>? _readStringList(Object? value) {
    if (value is! List) {
      return null;
    }

    try {
      return value.cast<String>().toList(growable: false);
    } on Object {
      return null;
    }
  }
}
