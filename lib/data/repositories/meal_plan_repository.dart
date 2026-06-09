import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class MealPlanRepository {
  MealPlanRepository({
    required this.aiProxyService,
    required this.localDataStore,
    this.shoppingListRepository,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AiProxyService aiProxyService;
  final LocalDataStore localDataStore;
  final ShoppingListRepository? shoppingListRepository;
  final DateTime Function() _now;
  AiQuotaUsage? lastPlanGenerationUsage;
  AiQuotaUsage? lastMealReplacementUsage;

  Future<MealPlanGenerationResult> generateActiveMealPlanWithUsage(
    UserProfile profile,
  ) async {
    final plan = await generateActiveMealPlan(profile);
    return MealPlanGenerationResult(plan: plan, usage: lastPlanGenerationUsage);
  }

  Future<MealPlan> generateActiveMealPlan(UserProfile profile) async {
    final payload = await aiProxyService.generateMealPlan(profile: profile);
    lastPlanGenerationUsage = AiQuotaUsage.maybeFromJson(payload['usage']);
    final planJson = _asJsonMap(payload['plan']);
    final plan = MealPlan.fromAiJson(planJson, generatedAt: _now());
    await localDataStore.saveActiveMealPlan(plan);
    await localDataStore.saveProfileNeedsPlanRegeneration(false);
    await shoppingListRepository?.regenerateFromActivePlan();
    return plan;
  }

  Future<List<Meal>> getDailyMeals() async {
    final localPlan = await _loadRequiredLocalMealPlan();
    return (await _currentDayFor(localPlan)).meals;
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final localPlan = await _loadRequiredLocalMealPlan();
    await _currentDayFor(localPlan);
    return localPlan.summary;
  }

  Future<MealPlan> replaceMeal(String mealId, {Meal? currentMeal}) async {
    final result = await replaceMealWithUsage(mealId, currentMeal: currentMeal);
    return result.plan;
  }

  Future<MealReplacementResult> replaceMealWithUsage(
    String mealId, {
    Meal? currentMeal,
  }) async {
    final localPlan = await _loadRequiredLocalMealPlan();
    final currentDay = await _currentDayFor(localPlan);

    final profile = await localDataStore.loadUserProfile();
    if (profile == null) {
      throw const MealPlanReplacementException(
        'Profil nutritionnel indisponible pour remplacer ce repas.',
      );
    }

    final displayedMeal = currentMeal;
    final storedMeal =
        _findMeal(localPlan, mealId) ??
        (displayedMeal == null
            ? null
            : _findMealByType(currentDay.meals, displayedMeal.type));
    if (storedMeal == null) {
      throw const MealPlanReplacementException(
        'Repas introuvable dans le plan actif.',
      );
    }
    final mealForPrompt = displayedMeal ?? storedMeal;

    final payload = await aiProxyService.replaceMeal(
      profile: profile,
      currentMeal: mealForPrompt,
      planContext: {
        'plan': localPlan.toJson(),
        'currentDay': currentDay.toJson(),
      },
    );
    lastMealReplacementUsage = AiQuotaUsage.maybeFromJson(payload['usage']);
    final replacementJson = _asJsonMap(payload['meal']);

    if (replacementJson['type'] != storedMeal.type) {
      throw const MealPlanReplacementException(
        'Alternative IA invalide pour ce repas.',
      );
    }

    final replacement = Meal.fromJson({
      ...replacementJson,
      'id': storedMeal.id,
    });
    final updatedPlan = localPlan.replaceMeal(replacement);
    await localDataStore.saveActiveMealPlan(updatedPlan);
    await shoppingListRepository?.regenerateFromActivePlan();
    return MealReplacementResult(
      plan: updatedPlan,
      usage: lastMealReplacementUsage,
    );
  }

  Future<Set<String>> getConsumedMealIds(String dayKey) async {
    return localDataStore.loadConsumedMealIds(dayKey);
  }

  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds) async {
    await localDataStore.saveConsumedMealIds(dayKey, mealIds);
  }

  Future<MealPlan?> _loadLocalMealPlan() async {
    try {
      return localDataStore.loadActiveMealPlan();
    } catch (_) {
      return null;
    }
  }

  Future<MealPlan> _loadRequiredLocalMealPlan() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan == null) {
      throw const MealPlanUnavailableException(
        'Aucun plan IA actif. Générez un plan pour continuer.',
      );
    }

    return localPlan;
  }

  Future<MealPlanDay> _currentDayFor(MealPlan plan) async {
    try {
      return plan.dayFor(_now());
    } on RangeError {
      try {
        await localDataStore.saveProfileNeedsPlanRegeneration(true);
      } catch (_) {
        // Loading should still fail with the actionable expired-plan message.
      }
      throw const MealPlanUnavailableException(
        'Votre plan IA a expiré. Régénérez un plan pour continuer.',
      );
    }
  }

  Meal? _findMeal(MealPlan plan, String mealId) {
    for (final day in plan.days) {
      for (final meal in day.meals) {
        if (meal.id == mealId) {
          return meal;
        }
      }
    }

    return null;
  }

  Meal? _findMealByType(List<Meal> meals, String type) {
    for (final meal in meals) {
      if (meal.type == type) {
        return meal;
      }
    }

    return null;
  }

  Map<String, Object?> _asJsonMap(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }

    if (value is Map) {
      return value.cast<String, Object?>();
    }

    throw const AiProxyException(
      code: 'invalid-response',
      message: 'Réponse IA invalide.',
    );
  }
}

class MealPlanGenerationResult {
  const MealPlanGenerationResult({required this.plan, required this.usage});

  final MealPlan plan;
  final AiQuotaUsage? usage;
}

class MealReplacementResult {
  const MealReplacementResult({required this.plan, required this.usage});

  final MealPlan plan;
  final AiQuotaUsage? usage;
}

class MealPlanReplacementException implements Exception {
  const MealPlanReplacementException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MealPlanUnavailableException implements Exception {
  const MealPlanUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}
