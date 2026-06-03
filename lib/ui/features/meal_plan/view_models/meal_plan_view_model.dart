import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({required this.mealPlanRepository}) {
    load();
  }

  final MealPlanRepository mealPlanRepository;

  ViewState<List<Meal>> mealsState = const ViewLoading();
  ViewState<NutritionSummary> summaryState = const ViewLoading();

  Future<void> load() async {
    mealsState = const ViewLoading();
    summaryState = const ViewLoading();
    notifyListeners();

    try {
      final meals = await mealPlanRepository.getDailyMeals();
      final summary = await mealPlanRepository.getNutritionSummary();
      mealsState = ViewData(meals);
      summaryState = ViewData(summary);
    } catch (error) {
      final message = error.toString();
      mealsState = ViewError(message);
      summaryState = ViewError(message);
    }

    notifyListeners();
  }

  Meal? mealById(String id) {
    return switch (mealsState) {
      ViewData(data: final meals) => _findMeal(meals, id),
      _ => null,
    };
  }

  Meal? _findMeal(List<Meal> meals, String id) {
    for (final meal in meals) {
      if (meal.id == id) {
        return meal;
      }
    }

    return null;
  }
}
