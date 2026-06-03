import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';

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
  });
}
