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

  Future<MealPlan> replaceMeal(String mealId) async {
    final localDataStore = this.localDataStore;
    if (localDataStore == null) {
      throw const MealPlanUnavailableException(
        'Stockage local indisponible pour remplacer ce repas.',
      );
    }

    final localPlan = await _loadLocalMealPlan();
    if (localPlan == null) {
      throw const MealPlanUnavailableException(
        'Aucun plan IA actif. Generez un plan pour continuer.',
      );
    }

    final profile = await localDataStore.loadUserProfile();
    if (profile == null) {
      throw const MealPlanReplacementException(
        'Profil nutritionnel indisponible pour remplacer ce repas.',
      );
    }

    final currentMeal = _findMeal(localPlan, mealId);
    if (currentMeal == null) {
      throw const MealPlanReplacementException(
        'Repas introuvable dans le plan actif.',
      );
    }

    final service = aiProxyService ?? AiProxyService();
    final payload = await service.replaceMeal(
      profile: profile,
      currentMeal: currentMeal,
      planContext: {
        'plan': localPlan.toJson(),
        'currentDay': localPlan.dayFor(_now()).toJson(),
      },
    );
    final replacement = Meal.fromJson(_asJsonMap(payload['meal']));

    if (replacement.id != currentMeal.id ||
        replacement.type != currentMeal.type) {
      throw const MealPlanReplacementException(
        'Alternative IA invalide pour ce repas.',
      );
    }

    final updatedPlan = localPlan.replaceMeal(replacement);
    await localDataStore.saveActiveMealPlan(updatedPlan);
    return updatedPlan;
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
