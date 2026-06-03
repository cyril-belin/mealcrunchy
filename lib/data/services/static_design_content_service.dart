class StaticDesignContentService {
  const StaticDesignContentService();

  Future<List<Map<String, Object?>>> fetchMeals() async {
    return const [
      {
        'id': 'avocado-toast',
        'type': 'PETIT-DEJEUNER',
        'name': 'Toast avocat et oeuf',
        'calories': 340,
        'protein': 18,
        'carbs': 24,
        'fat': 20,
        'imagePrompt': 'avocado toast with poached egg on a white plate',
        'duration': '15 min',
        'ingredients': [
          '2 tranches de pain complet',
          '1 avocat mur',
          '2 gros oeufs',
          'Flocons de piment rouge et sel de mer',
          'Jus de citron frais',
        ],
        'instructions': [
          'Faites griller le pain complet jusqu\'a ce qu\'il soit dore et croustillant.',
          'Ecrasez l\'avocat avec le jus de citron, le sel et les flocons de piment.',
          'Pochez les oeufs dans une eau fremissante pendant 3 a 4 minutes.',
          'Etalez l\'avocat sur les toasts et ajoutez les oeufs.',
        ],
      },
      {
        'id': 'chicken-quinoa',
        'type': 'DEJEUNER',
        'name': 'Bol quinoa au poulet grille',
        'calories': 520,
        'protein': 42,
        'carbs': 45,
        'fat': 12,
        'imagePrompt':
            'healthy quinoa bowl with grilled chicken and vegetables',
        'duration': '25 min',
        'ingredients': ['Quinoa', 'Poulet grille', 'Concombre', 'Tomates'],
        'instructions': ['Melangez le quinoa cuit, le poulet et les legumes.'],
      },
      {
        'id': 'yogurt-berries',
        'type': 'COLLATION',
        'name': 'Yaourt grec aux fruits rouges',
        'calories': 180,
        'protein': 15,
        'carbs': 20,
        'fat': 4,
        'imagePrompt': 'bowl of greek yogurt topped with blueberries and honey',
        'duration': '5 min',
        'ingredients': ['Yaourt grec', 'Myrtilles', 'Miel'],
        'instructions': ['Alternez yaourt, fruits rouges et un filet de miel.'],
      },
      {
        'id': 'salmon-asparagus',
        'type': 'DINER',
        'name': 'Saumon au four et asperges',
        'calories': 450,
        'protein': 35,
        'carbs': 10,
        'fat': 28,
        'imagePrompt': 'baked salmon fillet with roasted asparagus spears',
        'duration': '30 min',
        'ingredients': [
          'Filet de saumon',
          'Asperges',
          'Huile d\'olive',
          'Citron',
        ],
        'instructions': [
          'Faites cuire le saumon et les asperges au four jusqu\'a tendrete.',
        ],
      },
    ];
  }

  Future<Map<String, Object?>> fetchNutritionSummary() async {
    return const {
      'consumedCalories': 1850,
      'targetCalories': 2200,
      'progress': 0.84,
      'proteinPercent': 30,
      'carbsPercent': 45,
      'fatPercent': 25,
    };
  }

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
