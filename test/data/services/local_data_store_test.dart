import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

void main() {
  group('SharedPreferencesLocalDataStore', () {
    late _MemoryStringStore strings;
    late SharedPreferencesLocalDataStore store;

    setUp(() {
      strings = _MemoryStringStore();
      store = SharedPreferencesLocalDataStore(strings: strings);
    });

    test('saves and reloads a user profile', () async {
      await store.saveUserProfile(_profile);

      final reloaded = await store.loadUserProfile();

      expect(reloaded?.goal, 'Perdre du poids');
      expect(reloaded?.allergies, ['Cacahuetes']);
      expect(reloaded?.currentWeightKg, 82.5);
    });

    test('saves and reloads the active meal plan', () async {
      await store.saveActiveMealPlan(_mealPlan);

      final reloaded = await store.loadActiveMealPlan();

      expect(reloaded?.generatedAt, DateTime.utc(2026, 6, 7));
      expect(reloaded?.days, hasLength(7));
      expect(reloaded?.days.first.meals.single.id, 'breakfast');
      expect(reloaded?.summary.targetCalories, 2000);
    });

    test('updates consumed meals for one day', () async {
      await store.saveConsumedMealIds('2026-06-06', {'lunch', 'breakfast'});

      final mealIds = await store.loadConsumedMealIds('2026-06-06');

      expect(mealIds, {'breakfast', 'lunch'});
    });

    test('returns empty or null values when data is absent', () async {
      expect(await store.loadUserProfile(), isNull);
      expect(await store.loadActiveMealPlan(), isNull);
      expect(await store.loadConsumedMealIds('2026-06-06'), isEmpty);
      expect(await store.loadShoppingList(), isEmpty);
    });

    test('ignores invalid or incomplete JSON payloads', () async {
      await strings.setString(
        SharedPreferencesLocalDataStore.userProfileKey,
        '{',
      );
      await strings.setString(
        SharedPreferencesLocalDataStore.activeMealPlanKey,
        '{"meals":[{"id":"breakfast"}],"summary":{}}',
      );
      await strings.setString(
        SharedPreferencesLocalDataStore.consumedMealIdsKey('2026-06-06'),
        '{"ids":[1]}',
      );
      await strings.setString(
        SharedPreferencesLocalDataStore.shoppingListKey,
        '[{"id":"eggs"}]',
      );

      expect(await store.loadUserProfile(), isNull);
      expect(await store.loadActiveMealPlan(), isNull);
      expect(await store.loadConsumedMealIds('2026-06-06'), isEmpty);
      expect(await store.loadShoppingList(), isEmpty);
    });

    test('saves and reloads shopping list items', () async {
      await store.saveShoppingList(const [
        ShoppingListItem(
          id: 'eggs',
          name: 'Oeufs',
          quantity: '6',
          category: 'Proteines',
          checked: true,
        ),
      ]);

      final items = await store.loadShoppingList();

      expect(items.single.id, 'eggs');
      expect(items.single.checked, isTrue);
    });
  });
}

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

const _breakfast = Meal(
  id: 'breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Breakfast',
  calories: 400,
  protein: 30,
  carbs: 35,
  fat: 12,
  imagePrompt: 'breakfast',
  duration: '10 min',
  ingredients: ['Ingredient'],
  instructions: ['Instruction'],
);

const _summary = NutritionSummary(
  consumedCalories: 0,
  targetCalories: 2000,
  progress: 0,
  proteinPercent: 30,
  carbsPercent: 45,
  fatPercent: 25,
);

final _mealPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_breakfast],
    ),
  ),
  summary: _summary,
);

class _MemoryStringStore implements LocalStringStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> getString(String key) async => _values[key];

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }
}
