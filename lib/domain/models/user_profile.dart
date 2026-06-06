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
}
