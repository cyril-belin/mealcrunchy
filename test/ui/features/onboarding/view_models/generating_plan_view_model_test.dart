import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/observability_service.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/generating_plan_view_model.dart';

void main() {
  group('GeneratingPlanViewModel', () {
    test('exposes loading then generated plan on success', () async {
      final repository = _GeneratingMealPlanRepository();
      final observabilityService = _RecordingObservabilityService();
      final viewModel = GeneratingPlanViewModel(
        mealPlanRepository: repository,
        localDataStore: _GeneratingLocalDataStore(userProfile: _profile),
        observabilityService: observabilityService,
      );

      final generation = viewModel.generate();

      expect(viewModel.state, isA<ViewLoading<MealPlan>>());
      await generation;

      expect(viewModel.state, isA<ViewData<MealPlan>>());
      expect(repository.generatedWithProfile, _profile);
      expect(viewModel.planGenerationUsage?.remaining, 0);
      expect(observabilityService.events, [
        'ai_plan_generation_started',
        'ai_plan_generation_succeeded:0',
      ]);
    });

    test('exposes a controlled error when profile is missing', () async {
      final viewModel = GeneratingPlanViewModel(
        mealPlanRepository: _GeneratingMealPlanRepository(),
        localDataStore: _GeneratingLocalDataStore(),
      );

      await viewModel.generate();

      expect(
        viewModel.state,
        isA<ViewError<MealPlan>>().having(
          (state) => state.message,
          'message',
          'Profil nutritionnel introuvable. Reprenez l\'onboarding.',
        ),
      );
    });

    test('exposes proxy errors without producing a plan', () async {
      final observabilityService = _RecordingObservabilityService();
      final viewModel = GeneratingPlanViewModel(
        mealPlanRepository: _GeneratingMealPlanRepository(
          exception: const AiProxyException(
            code: 'resource-exhausted',
            message: 'Quota IA temporairement atteint.',
          ),
        ),
        localDataStore: _GeneratingLocalDataStore(userProfile: _profile),
        observabilityService: observabilityService,
      );

      await viewModel.generate();

      expect(
        viewModel.state,
        isA<ViewError<MealPlan>>().having(
          (state) => state.message,
          'message',
          'Quota IA temporairement atteint.',
        ),
      );
      expect(observabilityService.events, [
        'ai_plan_generation_started',
        'ai_plan_generation_failed:resource-exhausted',
      ]);
    });

    test(
      'hides unexpected generation errors behind a generic message',
      () async {
        final viewModel = GeneratingPlanViewModel(
          mealPlanRepository: _GeneratingMealPlanRepository(
            exception: StateError('debug generation failure'),
          ),
          localDataStore: _GeneratingLocalDataStore(userProfile: _profile),
        );

        await viewModel.generate();

        expect(
          viewModel.state,
          isA<ViewError<MealPlan>>().having(
            (state) => state.message,
            'message',
            'Une erreur est survenue. Réessayez dans un instant.',
          ),
        );
      },
    );
  });
}

const _profile = UserProfile(
  goal: NutritionGoal.loseWeight,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Cacahuetes'],
  customAversions: ['Olives'],
  activityLevel: ActivityLevel.moderatelyActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

final _plan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_meal],
    ),
  ),
  summary: const NutritionSummary(
    consumedCalories: 0,
    targetCalories: 2100,
    progress: 0,
    proteinPercent: 32,
    carbsPercent: 43,
    fatPercent: 25,
  ),
);

const _meal = Meal(
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

class _GeneratingMealPlanRepository extends MealPlanRepository {
  _GeneratingMealPlanRepository({this.exception})
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _GeneratingLocalDataStore(),
      );

  final Object? exception;
  UserProfile? generatedWithProfile;

  @override
  Future<MealPlan> generateActiveMealPlan(UserProfile profile) async {
    generatedWithProfile = profile;
    final exception = this.exception;
    if (exception != null) {
      throw exception;
    }
    lastPlanGenerationUsage = const AiQuotaUsage(
      periodKey: '2026-06',
      limit: 1,
      used: 1,
      remaining: 0,
    );
    return _plan;
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

class _GeneratingLocalDataStore implements LocalDataStore {
  _GeneratingLocalDataStore({this.userProfile});

  final UserProfile? userProfile;

  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

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

class _RecordingObservabilityService implements ObservabilityService {
  final events = <String>[];

  @override
  NavigatorObserver? createNavigatorObserver() => null;

  @override
  Future<void> logAiPlanGenerationStarted() async {
    events.add('ai_plan_generation_started');
  }

  @override
  Future<void> logAiPlanGenerationSucceeded({AiQuotaUsage? usage}) async {
    events.add('ai_plan_generation_succeeded:${usage?.remaining}');
  }

  @override
  Future<void> logAiPlanGenerationFailed({String? code}) async {
    events.add('ai_plan_generation_failed:${code ?? 'unknown'}');
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {}
}
