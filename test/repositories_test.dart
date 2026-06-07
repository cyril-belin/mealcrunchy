import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

void main() {
  group('MealPlanRepository', () {
    test('maps static meal payloads to typed meals', () async {
      final repository = MealPlanRepository(
        contentService: const StaticDesignContentService(),
      );

      final meals = await repository.getDailyMeals();

      expect(meals, isNotEmpty);
      expect(meals.first.id, 'avocado-toast');
    });

    test(
      'returns locally saved active meal plan before static content',
      () async {
        final repository = MealPlanRepository(
          contentService: const StaticDesignContentService(),
          localDataStore: _FakeLocalDataStore(
            activeMealPlan: const LocalMealPlan(
              meals: [_localMeal],
              summary: _localSummary,
            ),
          ),
        );

        final meals = await repository.getDailyMeals();
        final summary = await repository.getNutritionSummary();

        expect(meals.single.id, 'local-breakfast');
        expect(summary.targetCalories, 2100);
      },
    );
  });

  group('PreferencesRepository', () {
    test('maps static preference payloads to typed preference items', () async {
      final repository = PreferencesRepository(
        contentService: const StaticDesignContentService(),
      );

      final preferences = await repository.getPreferences();

      expect(preferences, isNotEmpty);
      expect(preferences.first.title, 'Objectifs sante');
    });

    test('maps a locally saved profile to preference items', () async {
      final repository = PreferencesRepository(
        contentService: const StaticDesignContentService(),
        localDataStore: _FakeLocalDataStore(userProfile: _profile),
      );

      final preferences = await repository.getPreferences();

      expect(preferences.first.title, 'Objectifs sante');
      expect(preferences.first.value, 'Perdre du poids');
      expect(preferences[2].value, 'Cacahuetes - Olives');
    });
  });
}

const _localMeal = Meal(
  id: 'local-breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Local breakfast',
  calories: 410,
  protein: 28,
  carbs: 36,
  fat: 14,
  imagePrompt: 'local breakfast',
  duration: '12 min',
  ingredients: ['Ingredient'],
  instructions: ['Instruction'],
);

const _localSummary = NutritionSummary(
  consumedCalories: 0,
  targetCalories: 2100,
  progress: 0,
  proteinPercent: 35,
  carbsPercent: 40,
  fatPercent: 25,
);

const _profile = UserProfile(
  goal: 'Perdre du poids',
  dietStyle: 'Mediterraneen',
  allergies: ['Cacahuetes'],
  customAversions: ['Olives'],
  activityLevel: 'Moderement actif',
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

class _FakeLocalDataStore implements LocalDataStore {
  const _FakeLocalDataStore({this.activeMealPlan, this.userProfile});

  final LocalMealPlan? activeMealPlan;
  final UserProfile? userProfile;

  @override
  Future<LocalMealPlan?> loadActiveMealPlan() async => activeMealPlan;

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<void> saveActiveMealPlan({
    required List<Meal> meals,
    required NutritionSummary summary,
  }) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}
}
