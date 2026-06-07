import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/json_readers.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';

class UserProfile {
  const UserProfile({
    required this.goal,
    required this.dietStyle,
    required this.allergies,
    required this.customAversions,
    required this.activityLevel,
    required this.mealTiming,
    required this.age,
    required this.heightCm,
    required this.currentWeightKg,
    required this.targetWeightKg,
  });

  final NutritionGoal goal;
  final DietStyle dietStyle;
  final List<String> allergies;
  final List<String> customAversions;
  final ActivityLevel activityLevel;
  final List<String> mealTiming;
  final int age;
  final int heightCm;
  final double currentWeightKg;
  final double targetWeightKg;

  factory UserProfile.fromJson(Map<String, Object?> json) {
    return UserProfile(
      goal: NutritionGoal.fromValue(readJsonField<String>(json, 'goal')),
      dietStyle: DietStyle.fromValue(readJsonField<String>(json, 'dietStyle')),
      allergies: readStringList(json, 'allergies'),
      customAversions: readStringList(json, 'customAversions'),
      activityLevel: ActivityLevel.fromValue(
        readJsonField<String>(json, 'activityLevel'),
      ),
      mealTiming: readStringList(json, 'mealTiming'),
      age: readJsonField<int>(json, 'age'),
      heightCm: readJsonField<int>(json, 'heightCm'),
      currentWeightKg: readJsonField<double>(json, 'currentWeightKg'),
      targetWeightKg: readJsonField<double>(json, 'targetWeightKg'),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'goal': goal.value,
      'dietStyle': dietStyle.value,
      'allergies': allergies,
      'customAversions': customAversions,
      'activityLevel': activityLevel.value,
      'mealTiming': mealTiming,
      'age': age,
      'heightCm': heightCm,
      'currentWeightKg': currentWeightKg,
      'targetWeightKg': targetWeightKg,
    };
  }
}
