import 'package:mealcrunchy/domain/models/json_readers.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';

class MealPlan {
  const MealPlan({
    required this.generatedAt,
    required this.days,
    required this.summary,
  });

  static const requiredDayCount = 7;

  final DateTime generatedAt;
  final List<MealPlanDay> days;
  final NutritionSummary summary;

  factory MealPlan.fromAiJson(
    Map<String, Object?> json, {
    required DateTime generatedAt,
  }) {
    return MealPlan(
      generatedAt: generatedAt,
      days: _readDays(json['days']),
      summary: _readAiSummary(_asJsonMap(json['summary'])),
    )._requireValid();
  }

  factory MealPlan.fromJson(Map<String, Object?> json) {
    return MealPlan(
      generatedAt: DateTime.parse(readJsonField<String>(json, 'generatedAt')),
      days: _readDays(json['days']),
      summary: NutritionSummary.fromJson(_asJsonMap(json['summary'])),
    )._requireValid();
  }

  Map<String, Object?> toJson() {
    return {
      'generatedAt': generatedAt.toUtc().toIso8601String(),
      'days': days.map((day) => day.toJson()).toList(growable: false),
      'summary': summary.toJson(),
    };
  }

  MealPlanDay dayFor(DateTime date) {
    final start = DateTime.utc(
      generatedAt.year,
      generatedAt.month,
      generatedAt.day,
    );
    final current = DateTime.utc(date.year, date.month, date.day);
    final offset = current.difference(start).inDays.clamp(0, days.length - 1);
    return days[offset];
  }

  MealPlan _requireValid() {
    if (days.length != requiredDayCount) {
      throw const FormatException('Meal plan must contain exactly 7 days.');
    }

    return this;
  }

  static List<MealPlanDay> _readDays(Object? value) {
    if (value is! List) {
      throw const FormatException('Meal plan days must be a list.');
    }

    return value
        .map(_asJsonMap)
        .map(MealPlanDay.fromJson)
        .toList(growable: false);
  }

  static NutritionSummary _readAiSummary(Map<String, Object?> json) {
    return NutritionSummary(
      consumedCalories: 0,
      targetCalories: readJsonField<int>(json, 'targetCalories'),
      progress: 0,
      proteinPercent: readJsonField<int>(json, 'proteinPercent'),
      carbsPercent: readJsonField<int>(json, 'carbsPercent'),
      fatPercent: readJsonField<int>(json, 'fatPercent'),
    );
  }
}

class MealPlanDay {
  const MealPlanDay({
    required this.id,
    required this.label,
    required this.meals,
  });

  final String id;
  final String label;
  final List<Meal> meals;

  factory MealPlanDay.fromJson(Map<String, Object?> json) {
    final mealsValue = json['meals'];
    if (mealsValue is! List) {
      throw const FormatException('Meal plan day meals must be a list.');
    }

    final meals = mealsValue
        .map(_asJsonMap)
        .map(Meal.fromJson)
        .toList(growable: false);
    if (meals.isEmpty) {
      throw const FormatException('Meal plan day must contain meals.');
    }

    return MealPlanDay(
      id: readJsonField<String>(json, 'id'),
      label: readJsonField<String>(json, 'label'),
      meals: meals,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'meals': meals.map((meal) => meal.toJson()).toList(growable: false),
    };
  }
}

Map<String, Object?> _asJsonMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }

  if (value is Map) {
    return value.cast<String, Object?>();
  }

  throw const FormatException('Expected a JSON object.');
}
