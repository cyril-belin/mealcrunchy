import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class MealPlanRepository {
  MealPlanRepository({
    this.aiProxyService,
    this.localDataStore,
    this.trackingStore = const SharedPreferencesDailyMealTrackingStore(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AiProxyService? aiProxyService;
  final LocalDataStore? localDataStore;
  final DailyMealTrackingStore trackingStore;
  final DateTime Function() _now;

  Future<MealPlan> generateActiveMealPlan(UserProfile profile) async {
    final service = aiProxyService ?? AiProxyService();
    final payload = await service.generateMealPlan(profile: profile);
    final planJson = _asJsonMap(payload['plan']);
    final plan = MealPlan.fromAiJson(planJson, generatedAt: _now());
    final localDataStore = this.localDataStore;
    if (localDataStore == null) {
      throw const MealPlanUnavailableException(
        'Stockage local indisponible pour sauvegarder le plan IA.',
      );
    }

    await localDataStore.saveActiveMealPlan(plan);
    return plan;
  }

  Future<List<Meal>> getDailyMeals() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.dayFor(_now()).meals;
    }

    throw const MealPlanUnavailableException(
      'Aucun plan IA actif. Generez un plan pour continuer.',
    );
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.summary;
    }

    throw const MealPlanUnavailableException(
      'Aucun plan IA actif. Generez un plan pour continuer.',
    );
  }

  Future<Set<String>> getConsumedMealIds(String dayKey) async {
    final localDataStore = this.localDataStore;
    if (localDataStore != null) {
      return localDataStore.loadConsumedMealIds(dayKey);
    }

    return trackingStore.loadConsumedMealIds(dayKey);
  }

  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds) async {
    final localDataStore = this.localDataStore;
    if (localDataStore != null) {
      await localDataStore.saveConsumedMealIds(dayKey, mealIds);
      return;
    }

    return trackingStore.saveConsumedMealIds(dayKey, mealIds);
  }

  Future<MealPlan?> _loadLocalMealPlan() async {
    final localDataStore = this.localDataStore;
    if (localDataStore == null) {
      return null;
    }

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
      message: 'Reponse IA invalide.',
    );
  }
}

class MealPlanUnavailableException implements Exception {
  const MealPlanUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}
