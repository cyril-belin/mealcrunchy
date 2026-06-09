# Déploiement

## Vue d'ensemble

MealCrunchy comprend deux parties à déployer :

1. application Flutter (mobile/web selon cible) ;
2. Firebase Cloud Functions + règles Firestore + configuration App Check.

## Préparation

Avant tout déploiement :

```bash
flutter analyze
flutter test
npm run build --prefix functions
npm test --prefix functions
```

## Firebase project

Projet :

```text
mealcrunchy-20260604
```

Région Functions :

```text
europe-west1
```

## Secrets Firebase

Configurer la clé OpenAI :

```bash
firebase functions:secrets:set OPENAI_API_KEY
```

Vérifier que les Functions déclarent le secret via `defineSecret` et `secrets: [openAiApiKey]`.

## Déployer les Functions

```bash
firebase deploy --only functions
```

Les callables exposés sont :

- `generateMealPlan` ;
- `replaceMeal`.

Les options runtime attendues :

- région `europe-west1` ;
- `timeoutSeconds: 120` ;
- `memory: 512MiB` ;
- `enforceAppCheck: true` ;
- secret `OPENAI_API_KEY`.

## Déployer les règles Firestore

```bash
firebase deploy --only firestore:rules
```

Les règles actuelles sont deny-all côté client. Les quotas sont manipulés via Admin SDK uniquement.

## App Check

À configurer dans Firebase Console pour chaque plateforme :

| Plateforme | Provider |
|---|---|
| Android | Play Integrity |
| iOS/macOS | App Attest + DeviceCheck fallback |
| Web | reCAPTCHA Enterprise |

Pour le web, injecter la clé au build :

```bash
flutter build web --dart-define=APP_CHECK_RECAPTCHA_SITE_KEY=YOUR_SITE_KEY
```

## Builds Flutter

### Android

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ipa --release
```

### Web

```bash
flutter build web --release --dart-define=APP_CHECK_RECAPTCHA_SITE_KEY=YOUR_SITE_KEY
```

## Emulateurs

Pour tester l'app contre Functions emulator :

```bash
flutter run --dart-define=USE_FUNCTIONS_EMULATOR=true
```

Le client pointe alors vers `localhost:5001` pour les Functions en debug.

## Checklist post-déploiement

- Connexion utilisateur OK.
- App Check accepté sur la plateforme cible.
- Génération plan IA OK.
- Quota génération décrémenté/affiché.
- Remplacement repas OK.
- Quota remplacement décrémenté/affiché.
- Crashlytics reçoit les erreurs non fatales/fatales.
- Analytics reçoit les événements IA et navigation.
- Firestore refuse les accès directs client.
