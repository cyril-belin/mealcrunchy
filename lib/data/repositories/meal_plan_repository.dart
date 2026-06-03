import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';

class MealPlanRepository {
  const MealPlanRepository({required this.contentService});

  final StaticDesignContentService contentService;

  Future<List<Meal>> getDailyMeals() async {
    final meals = await contentService.fetchMeals();
    return meals.map(Meal.fromJson).toList(growable: false);
  }

  Future<NutritionSummary> getNutritionSummary() async {
    final summary = await contentService.fetchNutritionSummary();
    return NutritionSummary.fromJson(summary);
  }
}
