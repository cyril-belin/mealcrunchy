import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';

import '../../helpers/fake_local_data_store.dart';

void main() {
  group('ShoppingListRepository', () {
    test(
      'extracts ingredients from all meals in the active 7 day plan',
      () async {
        final store = FakeLocalDataStore()
          ..activeMealPlan = _planWithIngredients([
            ['2 oeufs', 'Pain complet'],
            ['Yaourt grec'],
            ['Riz complet'],
          ]);
        final repository = ShoppingListRepository(localDataStore: store);

        final items = await repository.regenerateFromActivePlan();

        expect(
          items.map((item) => item.name),
          containsAll(<String>[
            'oeufs',
            'Pain complet',
            'Yaourt grec',
            'Riz complet',
          ]),
        );
        expect(store.shoppingList, items);
      },
    );

    test(
      'merges simple duplicates ignoring case and repeated spaces',
      () async {
        final store = FakeLocalDataStore()
          ..activeMealPlan = _planWithIngredients([
            ['Pain complet', '  pain   complet  ', 'Pomme'],
          ]);
        final repository = ShoppingListRepository(localDataStore: store);

        final items = await repository.regenerateFromActivePlan();

        expect(items.where((item) => item.id == 'pain complet'), hasLength(1));
        expect(items.where((item) => item.name == 'Pomme'), hasLength(1));
      },
    );

    test('preserves compatible checked items after regeneration', () async {
      final store = FakeLocalDataStore()
        ..shoppingList = const [
          ShoppingListItem(
            id: 'pain complet',
            name: 'Pain complet',
            quantity: '',
            category: 'Autres',
            checked: true,
          ),
        ]
        ..activeMealPlan = _planWithIngredients([
          ['Pain complet', 'Avocat'],
        ]);
      final repository = ShoppingListRepository(localDataStore: store);

      final items = await repository.regenerateFromActivePlan();

      expect(
        items.singleWhere((item) => item.id == 'pain complet').checked,
        isTrue,
      );
      expect(items.singleWhere((item) => item.id == 'avocat').checked, isFalse);
    });

    test('throws a controlled error when no active plan exists', () async {
      final repository = ShoppingListRepository(
        localDataStore: FakeLocalDataStore(),
      );

      await expectLater(
        repository.regenerateFromActivePlan(),
        throwsA(isA<ShoppingListUnavailableException>()),
      );
    });
  });
}

MealPlan _planWithIngredients(List<List<String>> mealIngredients) {
  var mealIndex = 0;
  return MealPlan(
    generatedAt: DateTime.utc(2026, 6, 7),
    summary: const NutritionSummary(
      consumedCalories: 0,
      targetCalories: 2000,
      progress: 0,
      proteinPercent: 30,
      carbsPercent: 45,
      fatPercent: 25,
    ),
    days: List.generate(7, (dayIndex) {
      return MealPlanDay(
        id: 'day-${dayIndex + 1}',
        label: 'Jour ${dayIndex + 1}',
        meals: List.generate(mealIngredients.length, (index) {
          final ingredients = mealIngredients[index];
          final id = 'meal-${mealIndex++}';
          return Meal(
            id: id,
            type: 'DEJEUNER',
            name: 'Repas $id',
            calories: 450,
            protein: 30,
            carbs: 40,
            fat: 15,
            imagePrompt: 'healthy meal',
            duration: '20 min',
            ingredients: ingredients,
            instructions: const ['Instruction'],
          );
        }),
      );
    }),
  );
}
