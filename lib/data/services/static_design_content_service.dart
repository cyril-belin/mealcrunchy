class StaticDesignContentService {
  const StaticDesignContentService();

  Future<List<Map<String, Object?>>> fetchPreferenceItems() async {
    return const [
      {
        'title': 'Objectifs sante',
        'value': 'Perte de poids - Prise de muscle',
        'iconName': 'target',
        'colorToken': 'info',
      },
      {
        'title': 'Regime alimentaire',
        'value': 'Mediterraneen - Riche en proteines',
        'iconName': 'restaurant',
        'colorToken': 'success',
      },
      {
        'title': 'Allergies et aversions',
        'value': 'Cacahuetes - Fruits de mer - Olives',
        'iconName': 'warning',
        'colorToken': 'error',
      },
      {
        'title': 'Niveau d\'activite',
        'value': 'Moderement actif (3-5 jours/semaine)',
        'iconName': 'fitness',
        'colorToken': 'warning',
      },
      {
        'title': 'Mensurations',
        'value': '28 ans - 175 cm - Homme',
        'iconName': 'straightener',
        'colorToken': 'primary',
      },
    ];
  }
}
