import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';

void main() {
  group('MealPlan', () {
    test('parses a valid 7 day AI plan', () {
      final plan = MealPlan.fromAiJson(
        _planJson(days: 7),
        generatedAt: DateTime.utc(2026, 6, 7),
      );

      expect(plan.generatedAt, DateTime.utc(2026, 6, 7));
      expect(plan.days, hasLength(7));
      expect(plan.days.first.id, 'day-1');
      expect(plan.days.first.meals.first.id, 'day-1-breakfast');
      expect(plan.summary.targetCalories, 2100);
      expect(plan.summary.consumedCalories, 0);
      expect(plan.summary.progress, 0);
      expect(plan.summary.proteinPercent, 32);
    });

    test('rejects AI plans that do not contain exactly 7 days', () {
      expect(
        () => MealPlan.fromAiJson(
          _planJson(days: 6),
          generatedAt: DateTime.utc(2026, 6, 7),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('round trips through local JSON with generated date', () {
      final plan = MealPlan.fromAiJson(
        _planJson(days: 7),
        generatedAt: DateTime.utc(2026, 6, 7, 8, 30),
      );

      final reloaded = MealPlan.fromJson(plan.toJson());

      expect(reloaded.generatedAt, DateTime.utc(2026, 6, 7, 8, 30));
      expect(reloaded.days.last.id, 'day-7');
      expect(reloaded.summary.carbsPercent, 43);
    });
  });
}

Map<String, Object?> _planJson({required int days}) {
  return {
    'days': List.generate(days, (index) {
      final dayNumber = index + 1;
      return {
        'id': 'day-$dayNumber',
        'label': 'Jour $dayNumber',
        'meals': [
          _mealJson(id: 'day-$dayNumber-breakfast', type: 'PETIT-DEJEUNER'),
          _mealJson(id: 'day-$dayNumber-lunch', type: 'DEJEUNER'),
          _mealJson(id: 'day-$dayNumber-dinner', type: 'DINER'),
        ],
      };
    }),
    'summary': {
      'targetCalories': 2100,
      'proteinPercent': 32,
      'carbsPercent': 43,
      'fatPercent': 25,
    },
  };
}

Map<String, Object?> _mealJson({required String id, required String type}) {
  return {
    'id': id,
    'type': type,
    'name': 'Repas $id',
    'calories': 450,
    'protein': 30,
    'carbs': 40,
    'fat': 15,
    'imagePrompt': 'healthy meal',
    'duration': '20 min',
    'ingredients': ['Ingredient'],
    'instructions': ['Instruction'],
  };
}
