import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';

void main() {
  group('MealPlanViewModel', () {
    test('starts in loading and exposes data after load completes', () async {
      final viewModel = MealPlanViewModel(
        mealPlanRepository: _SuccessfulMealPlanRepository(),
      );

      expect(viewModel.mealsState, isA<ViewLoading<List<Meal>>>());
      expect(viewModel.summaryState, isA<ViewLoading<NutritionSummary>>());

      await Future<void>.delayed(Duration.zero);

      final mealsState = viewModel.mealsState;
      final summaryState = viewModel.summaryState;
      expect(mealsState, isA<ViewData<List<Meal>>>());
      expect(summaryState, isA<ViewData<NutritionSummary>>());
      expect((mealsState as ViewData<List<Meal>>).data.single.id, 'test-meal');
      expect(viewModel.mealById('test-meal')?.name, 'Test meal');
    });

    test('exposes error states when loading fails', () async {
      final viewModel = MealPlanViewModel(
        mealPlanRepository: _ThrowingMealPlanRepository(),
      );

      await Future<void>.delayed(Duration.zero);

      expect(viewModel.mealsState, isA<ViewError<List<Meal>>>());
      expect(viewModel.summaryState, isA<ViewError<NutritionSummary>>());
    });
  });

  group('ProfileViewModel', () {
    test(
      'starts in loading and exposes preferences after load completes',
      () async {
        final viewModel = ProfileViewModel(
          preferencesRepository: _SuccessfulPreferencesRepository(),
        );

        expect(
          viewModel.preferencesState,
          isA<ViewLoading<List<PreferenceItem>>>(),
        );

        await Future<void>.delayed(Duration.zero);

        final state = viewModel.preferencesState;
        expect(state, isA<ViewData<List<PreferenceItem>>>());
        expect(
          (state as ViewData<List<PreferenceItem>>).data.single.title,
          'Goal',
        );
      },
    );

    test('exposes an error state when loading fails', () async {
      final viewModel = ProfileViewModel(
        preferencesRepository: _ThrowingPreferencesRepository(),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.preferencesState,
        isA<ViewError<List<PreferenceItem>>>(),
      );
    });
  });
}

const _meal = Meal(
  id: 'test-meal',
  type: 'DINER',
  name: 'Test meal',
  calories: 400,
  protein: 30,
  carbs: 35,
  fat: 12,
  imagePrompt: 'test meal',
  duration: '20 min',
  ingredients: ['Ingredient'],
  instructions: ['Instruction'],
);

const _summary = NutritionSummary(
  consumedCalories: 400,
  targetCalories: 2000,
  progress: 0.2,
  proteinPercent: 30,
  carbsPercent: 45,
  fatPercent: 25,
);

const _preference = PreferenceItem(
  title: 'Goal',
  value: 'Healthy eating',
  iconName: 'target',
  colorToken: 'info',
);

class _SuccessfulMealPlanRepository extends MealPlanRepository {
  _SuccessfulMealPlanRepository()
    : super(
        contentService: const StaticDesignContentService(),
        trackingStore: MemoryDailyMealTrackingStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_meal];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _summary;
}

class _ThrowingMealPlanRepository extends MealPlanRepository {
  _ThrowingMealPlanRepository()
    : super(
        contentService: const StaticDesignContentService(),
        trackingStore: MemoryDailyMealTrackingStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => throw Exception('load failed');

  @override
  Future<NutritionSummary> getNutritionSummary() async => _summary;
}

class _SuccessfulPreferencesRepository extends PreferencesRepository {
  _SuccessfulPreferencesRepository()
    : super(contentService: const StaticDesignContentService());

  @override
  Future<List<PreferenceItem>> getPreferences() async => const [_preference];
}

class _ThrowingPreferencesRepository extends PreferencesRepository {
  _ThrowingPreferencesRepository()
    : super(contentService: const StaticDesignContentService());

  @override
  Future<List<PreferenceItem>> getPreferences() async {
    throw Exception('load failed');
  }
}
