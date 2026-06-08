/// Niveau d'activite physique de l'utilisateur.
///
/// [value] est la chaine stockee localement et envoyee au backend IA ;
/// elle sert aussi de libelle d'affichage.
enum ActivityLevel {
  sedentary('Sédentaire'),
  lightlyActive('Légèrement actif'),
  moderatelyActive('Modérément actif'),
  veryActive('Très actif');

  const ActivityLevel(this.value);

  final String value;

  static ActivityLevel fromValue(String value) {
    final legacyValue = _legacyValues[value];
    if (legacyValue != null) {
      return legacyValue;
    }

    return values.firstWhere(
      (level) => level.value == value,
      orElse: () =>
          throw FormatException('Niveau d\'activité inconnu : $value'),
    );
  }

  static const _legacyValues = {
    'Sedentaire': sedentary,
    'Legerement actif': lightlyActive,
    'Moderement actif': moderatelyActive,
    'Tres actif': veryActive,
  };
}
