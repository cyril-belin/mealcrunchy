import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';

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

    test('exposes known loading errors as user messages', () async {
      final viewModel = MealPlanViewModel(
        mealPlanRepository: _ThrowingMealPlanRepository(
          exception: const MealPlanUnavailableException(
            'Aucun plan IA actif. Générez un plan pour continuer.',
          ),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.mealsState,
        isA<ViewError<List<Meal>>>().having(
          (state) => state.message,
          'message',
          'Aucun plan IA actif. Générez un plan pour continuer.',
        ),
      );
      expect(
        viewModel.summaryState,
        isA<ViewError<NutritionSummary>>().having(
          (state) => state.message,
          'message',
          'Aucun plan IA actif. Générez un plan pour continuer.',
        ),
      );
    });

    test('hides unexpected loading errors behind a generic message', () async {
      final viewModel = MealPlanViewModel(
        mealPlanRepository: _ThrowingMealPlanRepository(
          exception: StateError('debug loading failure'),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.mealsState,
        isA<ViewError<List<Meal>>>().having(
          (state) => state.message,
          'message',
          'Une erreur est survenue. Réessayez dans un instant.',
        ),
      );
      expect(
        viewModel.summaryState,
        isA<ViewError<NutritionSummary>>().having(
          (state) => state.message,
          'message',
          'Une erreur est survenue. Réessayez dans un instant.',
        ),
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

class _SuccessfulMealPlanRepository extends MealPlanRepository {
  _SuccessfulMealPlanRepository()
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _NoOpLocalDataStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_meal];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _summary;
}

class _ThrowingMealPlanRepository extends MealPlanRepository {
  _ThrowingMealPlanRepository({required this.exception})
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _NoOpLocalDataStore(),
      );

  final Object exception;

  @override
  Future<List<Meal>> getDailyMeals() async => throw exception;

  @override
  Future<NutritionSummary> getNutritionSummary() async => _summary;
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

class _NoOpLocalDataStore implements LocalDataStore {
  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async =>
      const <ShoppingListItem>[];

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<bool> loadProfileNeedsPlanRegeneration() async => false;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}

  @override
  Future<void> saveProfileNeedsPlanRegeneration(bool value) async {}
}
