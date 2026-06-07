import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class MealPlanRepository {
  MealPlanRepository({
    required this.aiProxyService,
    required this.localDataStore,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AiProxyService aiProxyService;
  final LocalDataStore localDataStore;
  final DateTime Function() _now;

  Future<MealPlan> generateActiveMealPlan(UserProfile profile) async {
    final payload = await aiProxyService.generateMealPlan(profile: profile);
    final planJson = _asJsonMap(payload['plan']);
    final plan = MealPlan.fromAiJson(planJson, generatedAt: _now());
    await localDataStore.saveActiveMealPlan(plan);
    return plan;
  }

  Future<List<Meal>> getDailyMeals() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.dayFor(_now()).meals;
    }

    throw const MealPlanUnavailableException(
      'Aucun plan IA actif. Générez un plan pour continuer.',
    );
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.summary;
    }

    throw const MealPlanUnavailableException(
      'Aucun plan IA actif. Générez un plan pour continuer.',
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

class MealPlanUnavailableException implements Exception {
  const MealPlanUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}
