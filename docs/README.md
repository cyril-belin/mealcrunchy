# Documentation MealCrunchy

Cette documentation décrit l'application MealCrunchy dans son ensemble : produit, architecture, backend IA, sécurité, développement, tests et exploitation.

## Index

| Document | Contenu |
|---|---|
| [Vue produit](./produit.md) | Objectif, utilisateurs, parcours, fonctionnalités livrées |
| [Architecture technique](./architecture.md) | Couches Flutter, providers, routing, données, backend |
| [Backend IA et quotas](./backend-ia.md) | Cloud Functions, OpenAI Responses API, validation, quotas |
| [Sécurité](./securite.md) | Firebase Auth, App Check, secrets, Firestore rules |
| [Développement local](./developpement-local.md) | Installation, variables, émulateurs, commandes utiles |
| [Tests et qualité](./tests-qualite.md) | Stratégie de tests, commandes, analyse statique |
| [Déploiement](./deploiement.md) | Build mobile/web, Firebase Functions, App Check |
| [Runbook exploitation](./runbook.md) | Incidents fréquents, diagnostic, résolution |
| [Fonctionnalités détaillées](./fonctionnalites/) | Specs historiques et suivi par fonctionnalité |

## État actuel

- **Application Flutter** multiplateforme avec architecture MVVM.
- **Backend serverless** Firebase Cloud Functions v2 en région `europe-west1`.
- **IA** via OpenAI Responses API avec Structured Outputs stricts.
- **Sécurité** : Firebase Auth, App Check, secrets Firebase, règles Firestore deny-all.
- **Observabilité** : Firebase Crashlytics et Analytics via abstraction injectable.
- **Qualité validée** : `flutter analyze` sans issue, 137 tests Flutter, 10 tests Functions.

## Commandes principales

```bash
flutter pub get
npm install --prefix functions
flutter analyze
flutter test
npm test --prefix functions
```

Pour exécuter l'application avec les Functions en émulateur :

```bash
flutter run --dart-define=USE_FUNCTIONS_EMULATOR=true
```
