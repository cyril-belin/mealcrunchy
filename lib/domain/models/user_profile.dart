import 'package:mealcrunchy/domain/models/json_readers.dart';

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

  final String goal;
  final String dietStyle;
  final List<String> allergies;
  final List<String> customAversions;
  final String activityLevel;
  final List<String> mealTiming;
  final int age;
  final int heightCm;
  final double currentWeightKg;
  final double targetWeightKg;

  factory UserProfile.fromJson(Map<String, Object?> json) {
    return UserProfile(
      goal: readJsonField<String>(json, 'goal'),
      dietStyle: readJsonField<String>(json, 'dietStyle'),
      allergies: readStringList(json, 'allergies'),
      customAversions: readStringList(json, 'customAversions'),
      activityLevel: readJsonField<String>(json, 'activityLevel'),
      mealTiming: readStringList(json, 'mealTiming'),
      age: readJsonField<int>(json, 'age'),
      heightCm: readJsonField<int>(json, 'heightCm'),
      currentWeightKg: readJsonField<double>(json, 'currentWeightKg'),
      targetWeightKg: readJsonField<double>(json, 'targetWeightKg'),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'goal': goal,
      'dietStyle': dietStyle,
      'allergies': allergies,
      'customAversions': customAversions,
      'activityLevel': activityLevel,
      'mealTiming': mealTiming,
      'age': age,
      'heightCm': heightCm,
      'currentWeightKg': currentWeightKg,
      'targetWeightKg': targetWeightKg,
    };
  }
}
