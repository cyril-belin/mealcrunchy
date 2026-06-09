# Architecture technique

## Vue d'ensemble

MealCrunchy suit une architecture Flutter en couches avec séparation claire des responsabilités.

```text
UI Layer
  Views Flutter + ViewModels ChangeNotifier

Data Layer
  Repositories + Services + LocalDataStore

Domain Layer
  Modèles immuables, parsing JSON, règles de validité

Backend
  Firebase Cloud Functions v2 + OpenAI Responses API + Firestore quotas
```

## Structure des dossiers

```text
lib/
├── main.dart
├── data/
│   ├── repositories/
│   └── services/
├── domain/
│   └── models/
└── ui/
    ├── app.dart
    ├── core/
    └── features/
```

## Couche UI

La couche UI est organisée par fonctionnalité dans `lib/ui/features/`.

Chaque feature suit le pattern :

- **View** : widget Flutter responsable du rendu.
- **ViewModel** : `ChangeNotifier` responsable de l'état, des actions utilisateur et des appels repository.
- **ViewState** : état asynchrone typé (`ViewLoading`, `ViewData`, `ViewError`).

Avantages :

- logique testable sans widget ;
- séparation claire affichage / comportement ;
- états d'écran exhaustifs via `switch` Dart.

## Injection de dépendances

L'injection est centralisée dans `MealCrunchyApp` via `Provider`, `ProxyProvider` et `ChangeNotifierProxyProvider`.

Principaux services injectés :

- `AuthService` / `AuthRepository` ;
- `LocalDataStore` ;
- `AiProxyService` ;
- `MealPlanRepository` ;
- `ShoppingListRepository` ;
- `PreferencesRepository` ;
- `ObservabilityService`.

Les implementations de production sont remplaçables en tests par des fakes ou no-op services.

## Routing

`GoRouter` gère la navigation déclarative.

Le routeur applique :

- redirection depuis splash/auth si l'utilisateur est déjà connecté ;
- protection des routes privées si l'utilisateur n'est pas authentifié ;
- routage vers onboarding ou plan actif selon l'état local.

L'observabilité de navigation est branchée via `NavigatorObserver` fourni par `ObservabilityService`.

## Couche data

Les repositories orchestrent les services et la persistence locale.

Exemples :

- `MealPlanRepository` génère, charge, remplace un repas, gère le plan expiré et stocke les usages IA.
- `ShoppingListRepository` dérive la liste de courses depuis le plan actif.
- `PreferencesRepository` modifie le profil et marque si une régénération est nécessaire.
- `AuthRepository` traduit les erreurs Firebase Auth en messages utilisateur.

## Couche domain

Les modèles du dossier `domain/models` contiennent :

- types métier (`Meal`, `MealPlan`, `UserProfile`, `NutritionSummary`) ;
- enums métier (`NutritionGoal`, `DietStyle`, `ActivityLevel`) ;
- parsing JSON strict ;
- validations de cohérence.

Le modèle `MealPlan` impose notamment 7 jours et rejette les accès hors fenêtre de validité.

## Persistance locale

`SharedPreferencesLocalDataStore` stocke :

- profil utilisateur ;
- plan actif ;
- flag de régénération nécessaire ;
- repas consommés par jour ;
- liste de courses.

L'accès est abstrait par `LocalDataStore`, ce qui permet une migration future vers SQLite, Hive ou Firestore sans modifier les viewmodels.

## Observabilité

`ObservabilityService` masque Firebase Analytics et Crashlytics.

- En production : `FirebaseObservabilityService`.
- En tests : `NoopObservabilityService`.

Les erreurs de télémétrie sont volontairement ignorées pour ne jamais bloquer l'expérience utilisateur.
