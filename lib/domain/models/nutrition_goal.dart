/// Objectif nutritionnel principal de l'utilisateur.
///
/// [value] est la chaine stockee localement et envoyee au backend IA ;
/// elle sert aussi de libelle d'affichage.
enum NutritionGoal {
  loseWeight('Perdre du poids'),
  eatHealthier('Manger plus sainement'),
  buildMuscle('Prendre du muscle'),
  maintain('Maintenir');

  const NutritionGoal(this.value);

  final String value;

  static NutritionGoal fromValue(String value) {
    return values.firstWhere(
      (goal) => goal.value == value,
      orElse: () =>
          throw FormatException('Objectif nutritionnel inconnu : $value'),
    );
  }
}
