import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';

void main() {
  group('Meal.typeLabel', () {
    test('formats known meal types and falls back to the raw value', () {
      expect(_mealWithType('PETIT-DEJEUNER').typeLabel, 'Petit-déjeuner');
      expect(_mealWithType('DEJEUNER').typeLabel, 'Déjeuner');
      expect(_mealWithType('COLLATION').typeLabel, 'Collation');
      expect(_mealWithType('DINER').typeLabel, 'Dîner');
      expect(_mealWithType('BRUNCH').typeLabel, 'BRUNCH');
    });
  });

  group('Meal.fromJson', () {
    test('parses a complete meal payload', () {
      final meal = Meal.fromJson({
        'id': 'avocado-toast',
        'type': 'PETIT-DEJEUNER',
        'name': 'Toast avocat et oeuf',
        'calories': 340,
        'protein': 18,
        'carbs': 24,
        'fat': 20,
        'imagePrompt': 'avocado toast',
        'duration': '15 min',
        'ingredients': ['Pain complet', 'Avocat'],
        'instructions': ['Griller le pain', 'Ajouter avocat'],
      });

      expect(meal.id, 'avocado-toast');
      expect(meal.calories, 340);
      expect(meal.ingredients, ['Pain complet', 'Avocat']);
      expect(meal.instructions, ['Griller le pain', 'Ajouter avocat']);
    });

    test('throws a FormatException when a required field is missing', () {
      expect(
        () => Meal.fromJson({
          'type': 'PETIT-DEJEUNER',
          'name': 'Toast avocat et oeuf',
          'calories': 340,
          'protein': 18,
          'carbs': 24,
          'fat': 20,
          'imagePrompt': 'avocado toast',
          'duration': '15 min',
          'ingredients': ['Pain complet'],
          'instructions': ['Griller le pain'],
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws a FormatException when a field has the wrong type', () {
      expect(
        () => Meal.fromJson({
          'id': 'avocado-toast',
          'type': 'PETIT-DEJEUNER',
          'name': 'Toast avocat et oeuf',
          'calories': '340',
          'protein': 18,
          'carbs': 24,
          'fat': 20,
          'imagePrompt': 'avocado toast',
          'duration': '15 min',
          'ingredients': ['Pain complet'],
          'instructions': ['Griller le pain'],
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('NutritionSummary.fromJson', () {
    test('parses a complete nutrition summary payload', () {
      final summary = NutritionSummary.fromJson({
        'consumedCalories': 1850,
        'targetCalories': 2200,
        'progress': 0.84,
        'proteinPercent': 30,
        'carbsPercent': 45,
        'fatPercent': 25,
      });

      expect(summary.consumedCalories, 1850);
      expect(summary.targetCalories, 2200);
      expect(summary.progress, 0.84);
      expect(summary.proteinPercent, 30);
    });

    test('throws a FormatException when a field has the wrong type', () {
      expect(
        () => NutritionSummary.fromJson({
          'consumedCalories': '1850',
          'targetCalories': 2200,
          'progress': 0.84,
          'proteinPercent': 30,
          'carbsPercent': 45,
          'fatPercent': 25,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws a FormatException when a required field is missing', () {
      expect(
        () => NutritionSummary.fromJson({
          'targetCalories': 2200,
          'progress': 0.84,
          'proteinPercent': 30,
          'carbsPercent': 45,
          'fatPercent': 25,
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('PreferenceItem.fromJson', () {
    test('parses a complete preference item payload', () {
      final item = PreferenceItem.fromJson({
        'title': 'Objectifs sante',
        'value': 'Perte de poids',
        'iconName': 'target',
        'colorToken': 'info',
      });

      expect(item.title, 'Objectifs sante');
      expect(item.value, 'Perte de poids');
      expect(item.iconName, 'target');
      expect(item.colorToken, 'info');
    });

    test('throws a FormatException when a field has the wrong type', () {
      expect(
        () => PreferenceItem.fromJson({
          'title': 'Objectifs sante',
          'value': 'Perte de poids',
          'iconName': 42,
          'colorToken': 'info',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws a FormatException when a required field is missing', () {
      expect(
        () => PreferenceItem.fromJson({
          'title': 'Objectifs sante',
          'value': 'Perte de poids',
          'iconName': 'target',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

Meal _mealWithType(String type) {
  return Meal(
    id: 'meal-$type',
    type: type,
    name: 'Meal',
    calories: 1,
    protein: 2,
    carbs: 3,
    fat: 4,
    imagePrompt: 'meal',
    duration: '5 min',
    ingredients: const ['Ingredient'],
    instructions: const ['Instruction'],
  );
}
