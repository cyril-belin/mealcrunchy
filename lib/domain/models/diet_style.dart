/// Style alimentaire suivi par l'utilisateur.
///
/// [value] est la chaine stockee localement et envoyee au backend IA ;
/// elle sert aussi de libelle d'affichage.
enum DietStyle {
  vegan('Vegan'),
  keto('Keto'),
  vegetarian('Végétarien'),
  paleo('Paleo'),
  glutenFree('Sans gluten'),
  mediterranean('Méditerranéen');

  const DietStyle(this.value);

  final String value;

  static DietStyle fromValue(String value) {
    final legacyValue = _legacyValues[value];
    if (legacyValue != null) {
      return legacyValue;
    }

    return values.firstWhere(
      (style) => style.value == value,
      orElse: () => throw FormatException('Style alimentaire inconnu : $value'),
    );
  }

  static const _legacyValues = {
    'Vegetarien': vegetarian,
    'Mediterraneen': mediterranean,
  };
}
