import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

import '../../helpers/fake_local_data_store.dart';

void main() {
  group('PreferencesRepository', () {
    test(
      'loads the saved profile with display rows and active plan calories',
      () async {
        final store = FakeLocalDataStore()
          ..userProfile = _profile
          ..activeMealPlan = _mealPlan
          ..profileNeedsPlanRegeneration = true;
        final repository = PreferencesRepository(localDataStore: store);

        final data = await repository.getProfilePreferences();

        expect(data.profile, same(_profile));
        expect(data.dailyTargetCalories, 1850);
        expect(data.profileNeedsPlanRegeneration, isTrue);
        expect(data.preferenceItems.map((item) => item.title), <String>[
          'Objectifs santé',
          'Régime alimentaire',
          'Allergies et aversions',
          'Niveau d\'activité',
          'Horaires de repas',
          'Mensurations',
        ]);
        expect(data.preferenceItems.first.value, 'Perdre du poids');
        expect(data.preferenceItems[2].value, 'Cacahuètes - Olives');
      },
    );

    test('throws a controlled error when no profile is saved', () async {
      final repository = PreferencesRepository(
        localDataStore: FakeLocalDataStore(),
      );

      await expectLater(
        repository.getProfilePreferences(),
        throwsA(
          isA<ProfilePreferencesUnavailableException>().having(
            (error) => error.message,
            'message',
            'Aucun profil nutritionnel sauvegardé.',
          ),
        ),
      );
    });
  });
}

const _profile = UserProfile(
  goal: NutritionGoal.loseWeight,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Cacahuètes'],
  customAversions: ['Olives'],
  activityLevel: ActivityLevel.moderatelyActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

final _mealPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  summary: const NutritionSummary(
    consumedCalories: 0,
    targetCalories: 1850,
    progress: 0,
    proteinPercent: 30,
    carbsPercent: 45,
    fatPercent: 25,
  ),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_meal],
    ),
  ),
);

const _meal = Meal(
  id: 'meal-1',
  type: 'DEJEUNER',
  name: 'Bowl énergie',
  calories: 520,
  protein: 36,
  carbs: 48,
  fat: 18,
  imagePrompt: 'healthy bowl',
  duration: '20 min',
  ingredients: ['Riz complet'],
  instructions: ['Assembler'],
);
