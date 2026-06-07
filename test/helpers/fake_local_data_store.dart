import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class FakeLocalDataStore implements LocalDataStore {
  UserProfile? userProfile;
  MealPlan? activeMealPlan;
  final Map<String, Set<String>> consumedMealIdsByDay = {};
  List<ShoppingListItem> shoppingList = const <ShoppingListItem>[];

  @override
  Future<MealPlan?> loadActiveMealPlan() async => activeMealPlan;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async {
    return consumedMealIdsByDay[dayKey]?.toSet() ?? <String>{};
  }

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async => shoppingList;

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {
    activeMealPlan = plan;
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
