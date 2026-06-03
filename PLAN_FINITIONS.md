# MealCrunchy — Plan de finitions (revue #2)

Ce document détaille les 3 chantiers de finition identifiés lors de la
deuxième revue de code, ordonnés par priorité. Aucune modification n'a encore
été appliquée — c'est un guide d'implémentation.

| # | Sujet | Type | Impact | Charge |
|---|-------|------|--------|--------|
| 1 | Cohérence des données (nombres magiques + code mort) | Bug | Élevé | 0,5 j |
| 2 | Migration des Views vers `switch` exhaustif + nettoyage | Refactor | Moyen | 0,5–1 j |
| 3 | Tests unitaires `fromJson` / `json_readers` | Qualité | Élevé | 0,5–1 j |

**Ordre conseillé : 1 → 2 → 3.**

---

## Priorité 1 — Corriger l'incohérence des données

### Problème
Dans `lib/ui/features/meal_plan/views/meal_details_screen.dart`, des nombres
magiques gonflent les valeurs affichées, créant une incohérence avec l'écran
liste qui affiche les valeurs brutes :

- `${meal.calories + 110} kcal`  → 340 dans la liste, 450 dans le détail
- `${meal.carbs + 8}g`
- `${meal.fat + 4}g`

De plus, deux conditions sont mortes ou fragiles :

- `meal.type.toLowerCase() == 'breakfast'` → jamais vrai (les types sont en
  français, ex. `PETIT-DEJEUNER`).
- `meal.name == 'Toast avocat et oeuf'` → special-casing en dur sur un nom.

### Objectif
La donnée doit être **la même partout** et venir du modèle, jamais transformée
dans la View.

### Étapes

1. **Supprimer les offsets** dans `meal_details_screen.dart` :
   - `${meal.calories + 110}` → `${meal.calories}`
   - `${meal.carbs + 8}` → `${meal.carbs}`
   - `${meal.fat + 4}` → `${meal.fat}`

2. **Supprimer la condition morte** sur le type. Afficher directement
   `meal.type` (déjà lisible), ou — mieux — normaliser l'affichage dans le
   modèle (voir étape 4).

3. **Supprimer le special-casing** sur `meal.name` : afficher `meal.name` tel
   quel. Si le nom complet est souhaité, corriger la donnée source dans
   `static_design_content_service.dart`.

4. **(Optionnel, recommandé)** Ajouter au modèle `Meal` un libellé d'affichage
   propre plutôt que de manipuler des chaînes dans la View :

   ```dart
   String get typeLabel {
     return switch (type) {
       'PETIT-DEJEUNER' => 'Petit-déjeuner',
       'DEJEUNER' => 'Déjeuner',
       'COLLATION' => 'Collation',
       'DINER' => 'Dîner',
       _ => type,
     };
   }
   ```

### Validation
- Ouvrir un repas depuis la liste : les kcal et macros doivent être
  **identiques** entre les deux écrans.
- `flutter analyze` vert (les conditions mortes supprimées peuvent retirer des
  warnings).

---

## Priorité 2 — Migrer les Views vers `switch` exhaustif + nettoyage

### Problème
Les Views consomment `ViewState` via des chaînes de `if (state is ViewLoading<...>)`
suivies de casts manuels `(state as ViewData<...>).data`. Le `sealed class`
permet un `switch` exhaustif **vérifié à la compilation**, sans cast.

Par ailleurs, `MealPlanRepository.getMeal` est devenu du code mort depuis que
`MealPlanViewModel.mealById` lit l'état local.

### Étapes

1. **`DailyMealPlanScreen`** — remplacer le bloc de `if/is/as` par :

   ```dart
   final mealsState = viewModel.mealsState;
   final summaryState = viewModel.summaryState;

   return switch ((mealsState, summaryState)) {
     (ViewLoading(), _) || (_, ViewLoading()) =>
       const AppScaffold(
         scrollable: false,
         child: Center(child: CircularProgressIndicator()),
       ),
     (ViewError(message: final m), _) =>
       _ErrorScaffold(message: m, onRetry: viewModel.load),
     (_, ViewError(message: final m)) =>
       _ErrorScaffold(message: m, onRetry: viewModel.load),
     (ViewData(data: final meals), ViewData(data: final summary)) =>
       _MealPlanContent(meals: meals, summary: summary),
   };
   ```

   Extraire le corps actuel dans un widget privé `_MealPlanContent`.

2. **`ProfilePreferencesScreen`** — même principe, plus simple (un seul état) :

   ```dart
   return switch (viewModel.preferencesState) {
     ViewLoading() => const AppScaffold(
         scrollable: false,
         child: Center(child: CircularProgressIndicator()),
       ),
     ViewError(message: final m) =>
       _ProfileErrorScaffold(message: m, onRetry: viewModel.load),
     ViewData(data: final preferences) =>
       _ProfileContent(preferences: preferences),
   };
   ```

3. **`MealDetailsScreen`** — conserver la logique loading/error, puis utiliser
   `mealById`. Le cas `meal == null` reste géré séparément (repas introuvable).

4. **Nettoyer le code mort** : supprimer `MealPlanRepository.getMeal` s'il
   n'est plus utilisé, OU le réutiliser dans `mealById` si on préfère
   centraliser la recherche dans le repository.

### Bénéfices
- Plus aucun cast `as` manuel.
- Si un nouvel état est ajouté à `ViewState`, le compilateur signale tous les
  `switch` à compléter.

### Validation
- `flutter analyze` vert (le `switch` doit être exhaustif, sinon erreur de
  compilation — c'est le but).
- Tester visuellement les 3 états sur chaque écran.

---

## Priorité 3 — Tests unitaires `fromJson` / `json_readers`

### Problème
La logique de parsing (`json_readers.dart` + les `fromJson`) lève des
`FormatException` mais n'est pas testée. C'est rapide à couvrir et protège
contre les régressions quand une vraie API arrivera.

### Étapes

1. Créer `test/domain/json_readers_test.dart` :

   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mealcrunchy/domain/models/json_readers.dart';

   void main() {
     group('readJsonField', () {
       test('retourne la valeur quand le type correspond', () {
         expect(readJsonField<int>({'a': 1}, 'a'), 1);
       });

       test('lève FormatException si la clé manque', () {
         expect(() => readJsonField<int>({}, 'a'), throwsFormatException);
       });

       test('lève FormatException si le type est mauvais', () {
         expect(
           () => readJsonField<int>({'a': 'x'}, 'a'),
           throwsFormatException,
         );
       });
     });

     group('readStringList', () {
       test('convertit une liste de chaînes', () {
         expect(readStringList({'a': ['x', 'y']}, 'a'), ['x', 'y']);
       });

       test('lève FormatException si ce n\'est pas une liste', () {
         expect(() => readStringList({'a': 1}, 'a'), throwsFormatException);
       });
     });
   }
   ```

2. Créer `test/domain/meal_test.dart` :

   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mealcrunchy/domain/models/meal.dart';

   void main() {
     final validJson = <String, Object?>{
       'id': 'avocado-toast',
       'type': 'PETIT-DEJEUNER',
       'name': 'Toast avocat et oeuf',
       'calories': 340,
       'protein': 18,
       'carbs': 24,
       'fat': 20,
       'imagePrompt': 'x',
       'duration': '15 min',
       'ingredients': ['a', 'b'],
       'instructions': ['c'],
     };

     test('Meal.fromJson parse un JSON valide', () {
       final meal = Meal.fromJson(validJson);
       expect(meal.id, 'avocado-toast');
       expect(meal.calories, 340);
       expect(meal.ingredients, hasLength(2));
     });

     test('Meal.fromJson lève FormatException si un champ manque', () {
       final invalid = Map<String, Object?>.from(validJson)..remove('calories');
       expect(() => Meal.fromJson(invalid), throwsFormatException);
     });
   }
   ```

3. Faire de même (cas valide + cas erreur) pour `NutritionSummary` et
   `PreferenceItem`.

4. Lancer la suite :

   ```bash
   flutter test
   ```

### Validation
- Tous les tests passent.
- Couverture des 3 modèles + des 2 helpers.

---

## Récapitulatif

1. **Cohérence des données** — corriger les offsets et conditions mortes pour
   que liste et détail affichent la même chose.
2. **`switch` exhaustif** — supprimer les casts manuels, profiter de la
   sécurité du `sealed class`, nettoyer le code mort.
3. **Tests `fromJson`** — verrouiller le parsing avant de brancher une vraie
   source de données.

Ces trois chantiers sont des finitions : aucun n'est bloquant, mais ensemble
ils font passer le projet de « très bon prototype » à « base saine et testée ».
