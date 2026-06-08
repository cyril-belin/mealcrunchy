import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({
    required this._mealPlanRepository,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    load();
  }

  final MealPlanRepository _mealPlanRepository;
  final DateTime Function() _now;

  ViewState<List<Meal>> mealsState = const ViewLoading();
  ViewState<NutritionSummary> summaryState = const ViewLoading();
  String? replacingMealId;
  String? replacementErrorMessage;
  Set<String> _consumedMealIds = <String>{};
  NutritionSummary? _targetSummary;

  String get currentDayLabel {
    final currentDate = _now();
    final monthName = switch (currentDate.month) {
      1 => 'janv.',
      2 => 'fev.',
      3 => 'mars',
      4 => 'avr.',
      5 => 'mai',
      6 => 'juin',
      7 => 'juil.',
      8 => 'aout',
      9 => 'sept.',
      10 => 'oct.',
      11 => 'nov.',
      12 => 'dec.',
      _ => '',
    };
    return 'Aujourd\'hui, ${currentDate.day} $monthName';
  }

  Future<void> load() async {
    mealsState = const ViewLoading();
    summaryState = const ViewLoading();
    notifyListeners();

    try {
      final meals = await _mealPlanRepository.getDailyMeals();
      final targetSummary = await _mealPlanRepository.getNutritionSummary();
      final consumedMealIds = await _mealPlanRepository.getConsumedMealIds(
        _dayKey,
      );
      _consumedMealIds = consumedMealIds;
      _targetSummary = targetSummary;
      mealsState = ViewData(meals);
      summaryState = ViewData(_buildConsumedSummary(meals, targetSummary));
    } catch (error) {
      final message = error.toString();
      mealsState = ViewError(message);
      summaryState = ViewError(message);
    }

    notifyListeners();
  }

  bool isMealConsumed(String id) => _consumedMealIds.contains(id);

  Future<bool> setMealConsumed(String id, {required bool consumed}) async {
    final meals = switch (mealsState) {
      ViewData<List<Meal>>(data: final data) => data,
      _ => null,
    };
    final targetSummary = _targetSummary;

    if (meals == null || targetSummary == null) {
      return false;
    }

    final nextConsumedMealIds = _consumedMealIds.toSet();
    if (consumed) {
      nextConsumedMealIds.add(id);
    } else {
      nextConsumedMealIds.remove(id);
    }

    try {
      await _mealPlanRepository.saveConsumedMealIds(
        _dayKey,
        nextConsumedMealIds,
      );
      _consumedMealIds = nextConsumedMealIds;
      summaryState = ViewData(_buildConsumedSummary(meals, targetSummary));
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> replaceMeal(String mealId) async {
    final meals = switch (mealsState) {
      ViewData<List<Meal>>(data: final data) => data,
      _ => null,
    };
    final targetSummary = _targetSummary;

    final currentMeal = meals == null ? null : _findMeal(meals, mealId);
    if (meals == null ||
        targetSummary == null ||
        currentMeal == null ||
        replacingMealId != null) {
      return false;
    }

    replacingMealId = mealId;
    replacementErrorMessage = null;
    notifyListeners();

    try {
      final updatedPlan = await _mealPlanRepository.replaceMeal(
        mealId,
        currentMeal: currentMeal,
      );
      final updatedMeals = updatedPlan.dayFor(_now()).meals;
      _targetSummary = updatedPlan.summary;
      mealsState = ViewData(updatedMeals);
      summaryState = ViewData(
        _buildConsumedSummary(updatedMeals, updatedPlan.summary),
      );
      return true;
    } catch (error) {
      replacementErrorMessage = error.toString();
      return false;
    } finally {
      replacingMealId = null;
      notifyListeners();
    }
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

  String get _dayKey {
    final currentDate = _now();
    final month = currentDate.month.toString().padLeft(2, '0');
    final day = currentDate.day.toString().padLeft(2, '0');
    return '${currentDate.year}-$month-$day';
  }

  NutritionSummary _buildConsumedSummary(
    List<Meal> meals,
    NutritionSummary targetSummary,
  ) {
    final consumedMeals = meals.where(
      (meal) => _consumedMealIds.contains(meal.id),
    );
    var consumedCalories = 0;
    var consumedProtein = 0;
    var consumedCarbs = 0;
    var consumedFat = 0;

    for (final meal in consumedMeals) {
      consumedCalories += meal.calories;
      consumedProtein += meal.protein;
      consumedCarbs += meal.carbs;
      consumedFat += meal.fat;
    }

    final totalMacros = consumedProtein + consumedCarbs + consumedFat;

    return NutritionSummary(
      consumedCalories: consumedCalories,
      targetCalories: targetSummary.targetCalories,
      progress: targetSummary.targetCalories == 0
          ? 0
          : (consumedCalories / targetSummary.targetCalories).clamp(0, 1),
      proteinPercent: totalMacros == 0
          ? 0
          : (consumedProtein / totalMacros * 100).round(),
      carbsPercent: totalMacros == 0
          ? 0
          : (consumedCarbs / totalMacros * 100).round(),
      fatPercent: totalMacros == 0
          ? 0
          : (consumedFat / totalMacros * 100).round(),
    );
  }
}
