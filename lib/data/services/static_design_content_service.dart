class StaticDesignContentService {
  const StaticDesignContentService();

  Future<List<Map<String, Object?>>> fetchPreferenceItems() async {
    return const [
      {
        'title': 'Objectifs santé',
        'value': 'Perte de poids - Prise de muscle',
        'iconName': 'target',
        'colorToken': 'info',
      },
      {
        'title': 'Régime alimentaire',
        'value': 'Méditerranéen - Riche en protéines',
        'iconName': 'restaurant',
        'colorToken': 'success',
      },
      {
        'title': 'Allergies et aversions',
        'value': 'Cacahuètes - Fruits de mer - Olives',
        'iconName': 'warning',
        'colorToken': 'error',
      },
      {
        'title': 'Niveau d\'activité',
        'value': 'Modérément actif (3-5 jours/semaine)',
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
