import 'package:mealcrunchy/domain/models/json_readers.dart';

class NutritionSummary {
  const NutritionSummary({
    required this.consumedCalories,
    required this.targetCalories,
    required this.progress,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final int consumedCalories;
  final int targetCalories;
  final double progress;
  final int proteinPercent;
  final int carbsPercent;
  final int fatPercent;

  factory NutritionSummary.fromJson(Map<String, Object?> json) {
    return NutritionSummary(
      consumedCalories: readJsonField<int>(json, 'consumedCalories'),
      targetCalories: readJsonField<int>(json, 'targetCalories'),
      progress: readJsonField<double>(json, 'progress'),
      proteinPercent: readJsonField<int>(json, 'proteinPercent'),
      carbsPercent: readJsonField<int>(json, 'carbsPercent'),
      fatPercent: readJsonField<int>(json, 'fatPercent'),
    );
  }
}
