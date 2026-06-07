import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  group('MealPlanViewModel daily tracking', () {
    test(
      'mealById returns the matching meal and null for an unknown id',
      () async {
        final viewModel = MealPlanViewModel(
          mealPlanRepository: _TrackingMealPlanRepository(
            localDataStore: FakeLocalDataStore(),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.mealById('breakfast'), same(_breakfast));
        expect(viewModel.mealById('missing-meal'), isNull);
      },
    );

    test('marking a meal consumed increases consumed calories', () async {
      final viewModel = MealPlanViewModel(
        mealPlanRepository: _TrackingMealPlanRepository(
          localDataStore: FakeLocalDataStore(),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      await viewModel.setMealConsumed('breakfast', consumed: true);

      final summary = viewModel.summaryState as ViewData<NutritionSummary>;
      expect(viewModel.isMealConsumed('breakfast'), isTrue);
      expect(summary.data.consumedCalories, 400);
      expect(summary.data.progress, 0.2);
    });

    test('unmarking a meal removes its calories from progress', () async {
      final localDataStore = FakeLocalDataStore()
        ..consumedMealIdsByDay['2026-06-06'] = {'breakfast', 'lunch'};
      final repository = _TrackingMealPlanRepository(
        localDataStore: localDataStore,
      );
      final viewModel = MealPlanViewModel(
        mealPlanRepository: repository,
        now: () => DateTime(2026, 6, 6),
      );
      await Future<void>.delayed(Duration.zero);

      await viewModel.setMealConsumed('breakfast', consumed: false);

      final summary = viewModel.summaryState as ViewData<NutritionSummary>;
      expect(viewModel.isMealConsumed('breakfast'), isFalse);
      expect(viewModel.isMealConsumed('lunch'), isTrue);
      expect(summary.data.consumedCalories, 600);
      expect(summary.data.progress, 0.3);
    });

    test('reloads consumed meals from local tracking storage', () async {
      final sharedLocalDataStore = FakeLocalDataStore()
        ..consumedMealIdsByDay['2026-06-06'] = {'breakfast'};
      final firstViewModel = MealPlanViewModel(
        mealPlanRepository: _TrackingMealPlanRepository(
          localDataStore: sharedLocalDataStore,
        ),
        now: () => DateTime(2026, 6, 6),
      );
      await Future<void>.delayed(Duration.zero);

      final secondViewModel = MealPlanViewModel(
        mealPlanRepository: _TrackingMealPlanRepository(
          localDataStore: sharedLocalDataStore,
        ),
        now: () => DateTime(2026, 6, 6),
      );
      await Future<void>.delayed(Duration.zero);

      final summary =
          secondViewModel.summaryState as ViewData<NutritionSummary>;
      expect(firstViewModel.isMealConsumed('breakfast'), isTrue);
      expect(secondViewModel.isMealConsumed('breakfast'), isTrue);
      expect(summary.data.consumedCalories, 400);
    });
  });
}

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

const _lunch = Meal(
  id: 'lunch',
  type: 'DEJEUNER',
  name: 'Lunch',
  calories: 600,
  protein: 35,
  carbs: 70,
  fat: 18,
  imagePrompt: 'lunch',
  duration: '20 min',
  ingredients: ['Ingredient'],
  instructions: ['Instruction'],
);

const _targetSummary = NutritionSummary(
  consumedCalories: 1850,
  targetCalories: 2000,
  progress: 0.92,
  proteinPercent: 30,
  carbsPercent: 45,
  fatPercent: 25,
);

class _TrackingMealPlanRepository extends MealPlanRepository {
  _TrackingMealPlanRepository({required LocalDataStore localDataStore})
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: localDataStore,
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_breakfast, _lunch];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _UnusedAiProxyService extends AiProxyService {
  _UnusedAiProxyService() : super(client: _UnusedAiCallableClient());
}

class _UnusedAiCallableClient implements AiCallableClient {
  @override
  Future<Object?> call(String name, Map<String, Object?> data) {
    throw UnimplementedError();
  }
}
