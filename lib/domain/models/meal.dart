import 'package:mealcrunchy/domain/models/json_readers.dart';

class Meal {
  const Meal({
    required this.id,
    required this.type,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imagePrompt,
    required this.duration,
    required this.ingredients,
    required this.instructions,
  });

  final String id;
  final String type;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String imagePrompt;
  final String duration;
  final List<String> ingredients;
  final List<String> instructions;

  String get typeLabel {
    return switch (type) {
      'PETIT-DEJEUNER' => 'Petit-déjeuner',
      'DEJEUNER' => 'Déjeuner',
      'COLLATION' => 'Collation',
      'DINER' => 'Dîner',
      _ => type,
    };
  }

  factory Meal.fromJson(Map<String, Object?> json) {
    return Meal(
      id: readJsonField<String>(json, 'id'),
      type: readJsonField<String>(json, 'type'),
      name: readJsonField<String>(json, 'name'),
      calories: readJsonField<int>(json, 'calories'),
      protein: readJsonField<int>(json, 'protein'),
      carbs: readJsonField<int>(json, 'carbs'),
      fat: readJsonField<int>(json, 'fat'),
      imagePrompt: readJsonField<String>(json, 'imagePrompt'),
      duration: readJsonField<String>(json, 'duration'),
      ingredients: readStringList(json, 'ingredients'),
      instructions: readStringList(json, 'instructions'),
    );
  }
}
