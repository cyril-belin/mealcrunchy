import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';

class MealPlanRepository {
  const MealPlanRepository({
    required this.contentService,
    this.localDataStore,
    this.trackingStore = const SharedPreferencesDailyMealTrackingStore(),
  });

  final StaticDesignContentService contentService;
  final LocalDataStore? localDataStore;
  final DailyMealTrackingStore trackingStore;

  Future<List<Meal>> getDailyMeals() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.meals;
    }

    final meals = await contentService.fetchMeals();
    return meals.map(Meal.fromJson).toList(growable: false);
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final localPlan = await _loadLocalMealPlan();
    if (localPlan != null) {
      return localPlan.summary;
    }

    final summary = await contentService.fetchNutritionSummary();
    return NutritionSummary.fromJson(summary);
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

  Future<LocalMealPlan?> _loadLocalMealPlan() async {
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
}
