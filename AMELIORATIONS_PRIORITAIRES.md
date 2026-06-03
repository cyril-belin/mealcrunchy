# MealCrunchy — Plan de mise en œuvre (Top 3 priorités)

Ce document détaille le plan d'action pour les 3 corrections prioritaires
identifiées lors de la revue de code. Aucune de ces modifications n'a encore
été appliquée — il s'agit d'un guide d'implémentation.

---

## Priorité 1 — Déclarer (ou retirer) la police `Plus Jakarta Sans`

### Problème
`lib/ui/core/theme/app_theme.dart` définit `fontFamily: 'Plus Jakarta Sans'`,
mais aucune police n'est déclarée dans `pubspec.yaml` (pas de section `fonts:`,
pas d'asset). Flutter retombe donc silencieusement sur la police système et le
rendu ne correspond pas au design voulu.

### Option A (recommandée) — Police locale via assets

1. Télécharger la famille « Plus Jakarta Sans » (Google Fonts, licence OFL).
2. Créer le dossier `assets/fonts/` et y placer les fichiers, par exemple :
   - `PlusJakartaSans-Regular.ttf` (400)
   - `PlusJakartaSans-Medium.ttf` (500)
   - `PlusJakartaSans-SemiBold.ttf` (600)
   - `PlusJakartaSans-Bold.ttf` (700)
   - `PlusJakartaSans-ExtraBold.ttf` (800)
3. Déclarer la famille dans `pubspec.yaml` :

   ```yaml
   flutter:
     uses-material-design: true
     fonts:
       - family: Plus Jakarta Sans
         fonts:
           - asset: assets/fonts/PlusJakartaSans-Regular.ttf
             weight: 400
           - asset: assets/fonts/PlusJakartaSans-Medium.ttf
             weight: 500
           - asset: assets/fonts/PlusJakartaSans-SemiBold.ttf
             weight: 600
           - asset: assets/fonts/PlusJakartaSans-Bold.ttf
             weight: 700
           - asset: assets/fonts/PlusJakartaSans-ExtraBold.ttf
             weight: 800
   ```

4. Lancer `flutter pub get` puis un hot restart (pas un simple hot reload).

### Option B — Package `google_fonts`

1. `flutter pub add google_fonts`
2. Dans `app_theme.dart`, remplacer `fontFamily: 'Plus Jakarta Sans'` par
   l'application du `TextTheme` via `GoogleFonts.plusJakartaSansTextTheme(...)`.
3. Avantage : pas de gestion d'assets. Inconvénient : téléchargement runtime au
   premier lancement (sauf si police mise en cache / embarquée).

### Validation
- Vérifier visuellement les titres (`displaySmall`, `headlineLarge`) sur le
  splash et l'écran d'auth.
- Réintroduire les accents corrects dans les textes une fois la police active.
- `flutter analyze` doit rester vert.

### Charge estimée
**0,5 à 1 jour** (selon option et nettoyage des textes accentués).

---

## Priorité 2 — Sérialisation typée (`fromJson`) à la place des casts manuels

### Problème
`MealPlanRepository` et `PreferencesRepository` font du parsing manuel verbeux
(`meal['calories']! as int`). C'est fragile : une clé manquante ou un mauvais
type provoque un crash runtime, et le code se duplique.

### Étape 1 — Ajouter `fromJson` aux modèles du domaine

Exemple pour `lib/domain/models/meal.dart` :

```dart
factory Meal.fromJson(Map<String, dynamic> json) {
  return Meal(
    id: json['id'] as String,
    type: json['type'] as String,
    name: json['name'] as String,
    calories: json['calories'] as int,
    protein: json['protein'] as int,
    carbs: json['carbs'] as int,
    fat: json['fat'] as int,
    imagePrompt: json['imagePrompt'] as String,
    duration: json['duration'] as String,
    ingredients: List<String>.from(json['ingredients'] as List),
    instructions: List<String>.from(json['instructions'] as List),
  );
}
```

Faire de même pour `NutritionSummary` et `PreferenceItem`.

### Étape 2 — Simplifier les repositories

```dart
List<Meal> getDailyMeals() {
  return contentService
      .fetchMeals()
      .map(Meal.fromJson)
      .toList(growable: false);
}
```

La logique de cast disparaît des repositories : ils orchestrent, les modèles
savent se construire.

### Étape 3 (optionnelle, recommandée à terme) — Génération de code

Quand une vraie API JSON arrivera, migrer vers `freezed` + `json_serializable`
pour générer `fromJson`/`toJson`/`copyWith`/égalité :

1. `flutter pub add freezed_annotation json_annotation`
2. `flutter pub add --dev build_runner freezed json_serializable`
3. Annoter les modèles, lancer `dart run build_runner build`.

### Remarque sur `getMeal`
Profiter de ce passage pour corriger `MealPlanRepository.getMeal` :
- ne plus appeler `getDailyMeals()` deux fois,
- retourner `Meal?` plutôt que de masquer l'erreur avec `orElse: first`.

### Validation
- Ajouter des tests unitaires sur les `fromJson` (cas nominal + clé manquante).
- `flutter analyze` vert.

### Charge estimée
**1 à 2 jours** (sans `freezed`) — **+0,5 jour** pour la migration `freezed`.

---

## Priorité 3 — État asynchrone dans les ViewModels

### Problème
Les ViewModels chargent les données de façon synchrone dans le constructeur
(`MealPlanViewModel`, `ProfileViewModel`). Dès qu'une vraie source de données
(API, base locale) sera branchée, il n'y aura aucun moyen d'afficher un
chargement ou une erreur.

### Étape 1 — Introduire un type d'état générique

Créer `lib/ui/core/state/view_state.dart` :

```dart
sealed class ViewState<T> {
  const ViewState();
}

class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

class ViewData<T> extends ViewState<T> {
  const ViewData(this.data);
  final T data;
}

class ViewError<T> extends ViewState<T> {
  const ViewError(this.message);
  final String message;
}
```

### Étape 2 — Adapter un ViewModel (ex. `MealPlanViewModel`)

```dart
class MealPlanViewModel extends ChangeNotifier {
  MealPlanViewModel({required this.mealPlanRepository}) {
    load();
  }

  final MealPlanRepository mealPlanRepository;

  ViewState<List<Meal>> mealsState = const ViewLoading();
  ViewState<NutritionSummary> summaryState = const ViewLoading();

  Future<void> load() async {
    mealsState = const ViewLoading();
    notifyListeners();
    try {
      final meals = await mealPlanRepository.getDailyMeals();
      final summary = await mealPlanRepository.getNutritionSummary();
      mealsState = ViewData(meals);
      summaryState = ViewData(summary);
    } catch (e) {
      mealsState = ViewError(e.toString());
      summaryState = ViewError(e.toString());
    }
    notifyListeners();
  }
}
```

> Note : cela suppose de passer les méthodes du repository/service en
> `Future` (asynchrones). Tant que les données sont statiques, on peut
> retourner `Future.value(...)` pour préparer la transition.

### Étape 3 — Gérer les états dans la View

Avec un `switch` sur l'état (pattern matching Dart 3) :

```dart
final state = context.watch<MealPlanViewModel>().mealsState;
return switch (state) {
  ViewLoading() => const Center(child: CircularProgressIndicator()),
  ViewError(message: final m) => ErrorView(message: m, onRetry: vm.load),
  ViewData(data: final meals) => MealList(meals: meals),
};
```

### Validation
- Tester les 3 états (loading / data / error) avec un repository simulé.
- Vérifier qu'un `onRetry` relance `load()`.

### Charge estimée
**1,5 à 2,5 jours** (création du type d'état + migration des 2-3 ViewModels +
adaptation des Views).

---

## Récapitulatif

| # | Sujet | Impact | Charge |
|---|-------|--------|--------|
| 1 | Police `Plus Jakarta Sans` | Rendu visuel conforme au design | 0,5–1 j |
| 2 | Sérialisation typée `fromJson` | Robustesse, moins de crash runtime | 1–2 j |
| 3 | État async dans les ViewModels | Prêt pour une vraie source de données | 1,5–2,5 j |

**Ordre conseillé : 1 → 2 → 3.**
La priorité 1 est rapide et corrige un défaut visuel immédiat ; les priorités 2
et 3 préparent le terrain pour brancher un backend réel sans refonte.
