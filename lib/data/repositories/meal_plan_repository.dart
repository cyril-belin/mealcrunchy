import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';

class MealPlanRepository {
  const MealPlanRepository({
    required this.contentService,
    this.trackingStore = const SharedPreferencesDailyMealTrackingStore(),
  });

  final StaticDesignContentService contentService;
  final DailyMealTrackingStore trackingStore;

  Future<List<Meal>> getDailyMeals() async {
    final meals = await contentService.fetchMeals();
    return meals.map(Meal.fromJson).toList(growable: false);
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final summary = await contentService.fetchNutritionSummary();
    return NutritionSummary.fromJson(summary);
  }

  Future<Set<String>> getConsumedMealIds(String dayKey) {
    return trackingStore.loadConsumedMealIds(dayKey);
  }

  Future<void> saveConsumedMealIds(String dayKey, Set<String> mealIds) {
    return trackingStore.saveConsumedMealIds(dayKey, mealIds);
  }
}
