import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

void main() {
  group('MealPlanRepository', () {
    test('generates and saves an active 7 day AI meal plan', () async {
      final aiProxyService = _FakeAiProxyService(
        response: {'plan': _planJson(days: 7)},
      );
      final localDataStore = _FakeLocalDataStore();
      final repository = MealPlanRepository(
        aiProxyService: aiProxyService,
        localDataStore: localDataStore,
        now: () => DateTime.utc(2026, 6, 7, 8),
      );

      final plan = await repository.generateActiveMealPlan(_profile);

      expect(plan.days, hasLength(7));
      expect(localDataStore.activeMealPlan?.days, hasLength(7));
      expect(aiProxyService.requestedProfile, _profile);
    });

    test('does not save a plan when AI generation fails', () async {
      final localDataStore = _FakeLocalDataStore();
      final repository = MealPlanRepository(
        aiProxyService: _FakeAiProxyService(exception: _aiException),
        localDataStore: localDataStore,
        now: () => DateTime.utc(2026, 6, 7, 8),
      );

      await expectLater(
        repository.generateActiveMealPlan(_profile),
        throwsA(same(_aiException)),
      );

      expect(localDataStore.activeMealPlan, isNull);
    });

    test('loads meals for the current day from the local AI plan', () async {
      final repository = MealPlanRepository(
        aiProxyService: _FakeAiProxyService(),
        localDataStore: _FakeLocalDataStore(
          activeMealPlan: MealPlan.fromAiJson(
            _planJson(days: 7),
            generatedAt: DateTime.utc(2026, 6, 7),
          ),
        ),
        now: () => DateTime.utc(2026, 6, 9),
      );

      final meals = await repository.getDailyMeals();
      final summary = await repository.getNutritionSummary();

      expect(meals.first.id, 'day-3-breakfast');
      expect(summary.targetCalories, 2100);
    });

    test('throws a controlled error when no active AI plan exists', () async {
      final repository = MealPlanRepository(
        aiProxyService: _FakeAiProxyService(),
        localDataStore: _FakeLocalDataStore(),
      );

      await expectLater(
        repository.getDailyMeals(),
        throwsA(
          isA<MealPlanUnavailableException>().having(
            (error) => error.message,
            'message',
            'Aucun plan IA actif. Generez un plan pour continuer.',
          ),
        ),
      );
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

    test('maps a locally saved profile to preference items', () async {
      final repository = PreferencesRepository(
        contentService: const StaticDesignContentService(),
        localDataStore: _FakeLocalDataStore(userProfile: _profile),
      );

      final preferences = await repository.getPreferences();

      expect(preferences.first.title, 'Objectifs sante');
      expect(preferences.first.value, 'Perdre du poids');
      expect(preferences[2].value, 'Cacahuetes - Olives');
    });
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

const _aiException = AiProxyException(
  code: 'unavailable',
  message: 'Generation IA momentanement indisponible.',
);

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

class _FakeAiProxyService extends AiProxyService {
  _FakeAiProxyService({this.response = const {}, this.exception})
    : super(client: _UnusedAiCallableClient());

  final Map<String, Object?> response;
  final AiProxyException? exception;
  UserProfile? requestedProfile;

  @override
  Future<Map<String, Object?>> generateMealPlan({
    required UserProfile profile,
    int days = 7,
    String locale = 'fr-FR',
  }) async {
    requestedProfile = profile;
    final exception = this.exception;
    if (exception != null) {
      throw exception;
    }
    return response;
  }
}

class _UnusedAiCallableClient implements AiCallableClient {
  @override
  Future<Object?> call(String name, Map<String, Object?> data) {
    throw UnimplementedError();
  }
}

class _FakeLocalDataStore implements LocalDataStore {
  _FakeLocalDataStore({this.activeMealPlan, this.userProfile});

  MealPlan? activeMealPlan;
  final UserProfile? userProfile;

  @override
  Future<MealPlan?> loadActiveMealPlan() async => activeMealPlan;

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {
    activeMealPlan = plan;
  }

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}
}
