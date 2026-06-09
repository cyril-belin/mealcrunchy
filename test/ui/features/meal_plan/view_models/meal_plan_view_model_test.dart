import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

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

    test('formats the current day label with French accents', () async {
      final februaryViewModel = MealPlanViewModel(
        mealPlanRepository: _TrackingMealPlanRepository(
          localDataStore: FakeLocalDataStore(),
        ),
        now: () => DateTime(2026, 2, 6),
      );
      final augustViewModel = MealPlanViewModel(
        mealPlanRepository: _TrackingMealPlanRepository(
          localDataStore: FakeLocalDataStore(),
        ),
        now: () => DateTime(2026, 8, 6),
      );

      expect(februaryViewModel.currentDayDateLabel, '6 février');
      expect(augustViewModel.currentDayDateLabel, '6 août');
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

    test('exposes loading for the meal currently being replaced', () async {
      final replacementCompleter = Completer<MealPlan>();
      final repository = _ReplacingMealPlanRepository(
        localDataStore: FakeLocalDataStore(),
        replacementCompleter: replacementCompleter,
      );
      final viewModel = MealPlanViewModel(
        mealPlanRepository: repository,
        now: () => DateTime(2026, 6, 6),
      );
      await Future<void>.delayed(Duration.zero);

      final replaceFuture = viewModel.replaceMeal('breakfast');
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.replacingMealId, 'breakfast');

      replacementCompleter.complete(_replacementPlan);
      expect(await replaceFuture, isTrue);
      expect(viewModel.replacingMealId, isNull);
    });

    test(
      'updates meals and consumed summary after replacement succeeds',
      () async {
        final repository = _ReplacingMealPlanRepository(
          localDataStore: FakeLocalDataStore()
            ..consumedMealIdsByDay['2026-06-06'] = {'breakfast'},
        );
        final viewModel = MealPlanViewModel(
          mealPlanRepository: repository,
          now: () => DateTime(2026, 6, 6),
        );
        await Future<void>.delayed(Duration.zero);

        final success = await viewModel.replaceMeal('breakfast');

        final meals = (viewModel.mealsState as ViewData<List<Meal>>).data;
        final summary = viewModel.summaryState as ViewData<NutritionSummary>;
        expect(success, isTrue);
        expect(meals.first.name, 'Breakfast remplace');
        expect(meals[1], same(_lunch));
        expect(summary.data.consumedCalories, 500);
        expect(viewModel.replacementErrorMessage, isNull);
        expect(viewModel.mealReplacementUsage?.remaining, 6);
      },
    );

    test(
      'keeps current meals and exposes an error when replacement fails',
      () async {
        final viewModel = MealPlanViewModel(
          mealPlanRepository: _ThrowingReplacementMealPlanRepository(
            localDataStore: FakeLocalDataStore(),
          ),
          now: () => DateTime(2026, 6, 6),
        );
        await Future<void>.delayed(Duration.zero);

        final success = await viewModel.replaceMeal('breakfast');

        final meals = (viewModel.mealsState as ViewData<List<Meal>>).data;
        expect(success, isFalse);
        expect(meals.first.name, 'Breakfast');
        expect(viewModel.replacingMealId, isNull);
        expect(
          viewModel.replacementErrorMessage,
          'Alternative IA indisponible.',
        );
      },
    );

    test(
      'hides unexpected replacement errors behind a generic message',
      () async {
        final viewModel = MealPlanViewModel(
          mealPlanRepository: _ThrowingReplacementMealPlanRepository(
            localDataStore: FakeLocalDataStore(),
            exception: StateError('debug replacement failure'),
          ),
          now: () => DateTime(2026, 6, 6),
        );
        await Future<void>.delayed(Duration.zero);

        final success = await viewModel.replaceMeal('breakfast');

        expect(success, isFalse);
        expect(
          viewModel.replacementErrorMessage,
          'Une erreur est survenue. Réessayez dans un instant.',
        );
      },
    );

    test(
      'exposes the quota error when monthly replacement quota is exhausted',
      () async {
        final viewModel = MealPlanViewModel(
          mealPlanRepository: _ThrowingReplacementMealPlanRepository(
            localDataStore: FakeLocalDataStore(),
            message: 'Quota IA temporairement atteint.',
          ),
          now: () => DateTime(2026, 6, 6),
        );
        await Future<void>.delayed(Duration.zero);

        final success = await viewModel.replaceMeal('breakfast');

        expect(success, isFalse);
        expect(
          viewModel.replacementErrorMessage,
          'Quota IA temporairement atteint.',
        );
      },
    );
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

const _replacementBreakfast = Meal(
  id: 'breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Breakfast remplace',
  calories: 500,
  protein: 38,
  carbs: 42,
  fat: 16,
  imagePrompt: 'replacement breakfast',
  duration: '12 min',
  ingredients: ['Ingredient remplace'],
  instructions: ['Instruction remplace'],
);

const _targetSummary = NutritionSummary(
  consumedCalories: 1850,
  targetCalories: 2000,
  progress: 0.92,
  proteinPercent: 30,
  carbsPercent: 45,
  fatPercent: 25,
);

final _replacementPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 6),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: index == 0
          ? const [_replacementBreakfast, _lunch]
          : const [_breakfast, _lunch],
    ),
  ),
  summary: _targetSummary,
);

class _TrackingMealPlanRepository extends MealPlanRepository {
  _TrackingMealPlanRepository({required super.localDataStore})
    : super(aiProxyService: _UnusedAiProxyService());

  @override
  Future<List<Meal>> getDailyMeals() async => const [_breakfast, _lunch];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _ReplacingMealPlanRepository extends _TrackingMealPlanRepository {
  _ReplacingMealPlanRepository({
    required super.localDataStore,
    this._replacementCompleter,
  });

  final Completer<MealPlan>? _replacementCompleter;

  @override
  Future<MealPlan> replaceMeal(String mealId, {Meal? currentMeal}) async {
    lastMealReplacementUsage = const AiQuotaUsage(
      periodKey: '2026-06',
      limit: 10,
      used: 4,
      remaining: 6,
    );
    return _replacementCompleter?.future ?? _replacementPlan;
  }
}

class _ThrowingReplacementMealPlanRepository
    extends _TrackingMealPlanRepository {
  _ThrowingReplacementMealPlanRepository({
    required super.localDataStore,
    this.message = 'Alternative IA indisponible.',
    this.exception,
  });

  final String message;
  final Object? exception;

  @override
  Future<MealPlan> replaceMeal(String mealId, {Meal? currentMeal}) async {
    final exception = this.exception;
    if (exception != null) {
      throw exception;
    }
    throw MealPlanReplacementException(message);
  }
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
