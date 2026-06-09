# Tests et qualité

## État validé

- `flutter analyze` : 0 issue.
- Tests Flutter : 137 tests passés.
- Tests Functions : 10 tests passés.

## Commandes

```bash
flutter analyze
flutter test
npm test --prefix functions
npm run build --prefix functions
```

## Stratégie de tests Flutter

Le projet couvre plusieurs niveaux :

| Niveau | Objectif |
|---|---|
| Domain models | Parsing, validation, round-trip JSON, règles métier |
| Repositories | Orchestration services, persistance, erreurs |
| ViewModels | États loading/data/error, actions utilisateur, side effects |
| Widgets | Rendu, interactions, routing, messages utilisateur |
| Config | Cohérence roadmap/docs quand applicable |

## Testabilité par design

Le code est conçu pour être testable :

- services abstraits (`AuthService`, `LocalDataStore`, `AiCallableClient`, `ObservabilityService`) ;
- injection via constructors/providers ;
- `DateTime Function()? now` pour rendre les dates déterministes ;
- `NoopObservabilityService` pour éviter Firebase en tests ;
- fakes locaux pour SharedPreferences et callables IA.

## Tests backend Functions

Les tests Node.js valident :

- refus des requêtes non authentifiées ;
- validation de profils invalides ;
- mapping des erreurs OpenAI ;
- validation des payloads OpenAI ;
- retour de plan validé ;
- quotas épuisés avant appel OpenAI ;
- libération de quota après échec ;
- remplacement de repas validé ;
- options runtime App Check/timeout/memory.

## Critères avant merge/push

Avant de pousser sur `main`, vérifier :

```bash
flutter analyze
flutter test
npm run build --prefix functions
npm test --prefix functions
```

Tous doivent passer.

## Qualité du code

Règles et conventions :

- architecture en couches ;
- erreurs utilisateur non techniques ;
- pas d'appel OpenAI direct côté client ;
- pas de secret dans le dépôt ;
- validations côté client et côté serveur ;
- composants UI réutilisables dans `ui/core/widgets` ;
- textes utilisateur via localisation lorsque possible.

## Points de vigilance

- Tout changement dans le schéma OpenAI doit être reflété côté Dart (`Meal`, `MealPlan`) et côté tests.
- Tout nouveau service externe doit être encapsulé derrière une abstraction injectable.
- Toute nouvelle route privée doit respecter les guards d'authentification.
- Toute modification des quotas doit être testée contre les appels concurrents.
