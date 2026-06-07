import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class FakeLocalDataStore implements LocalDataStore {
  UserProfile? userProfile;
  LocalMealPlan? activeMealPlan;
  final Map<String, Set<String>> consumedMealIdsByDay = {};
  List<ShoppingListItem> shoppingList = const <ShoppingListItem>[];

  @override
  Future<LocalMealPlan?> loadActiveMealPlan() async => activeMealPlan;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async {
    return consumedMealIdsByDay[dayKey]?.toSet() ?? <String>{};
  }

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async => shoppingList;

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

  @override
  Future<void> saveActiveMealPlan({
    required List<Meal> meals,
    required NutritionSummary summary,
  }) async {
    activeMealPlan = LocalMealPlan(meals: meals, summary: summary);
  }

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {
    consumedMealIdsByDay[dayKey] = ids.toSet();
  }

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {
    shoppingList = items;
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    userProfile = profile;
  }
}
