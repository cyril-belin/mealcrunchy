# Développement local

## Prérequis

- macOS, Windows ou Linux.
- Flutter SDK compatible avec le projet.
- Dart SDK compatible avec Flutter.
- Node.js >= 22 pour Firebase Functions.
- Firebase CLI si déploiement ou émulateurs.
- Un projet Firebase configuré.

## Installation

```bash
flutter pub get
npm install --prefix functions
```

## Configuration Firebase

Le projet utilise `lib/firebase_options.dart`, généré via FlutterFire CLI.

Si le projet Firebase doit être reconfiguré :

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Projet Firebase utilisé :

```text
mealcrunchy-20260604
```

Région Functions :

```text
europe-west1
```

## Lancer l'application

```bash
flutter run
```

Avec Functions emulator :

```bash
flutter run --dart-define=USE_FUNCTIONS_EMULATOR=true
```

Avec App Check Web reCAPTCHA Enterprise en production web :

```bash
flutter run --dart-define=APP_CHECK_RECAPTCHA_SITE_KEY=YOUR_SITE_KEY
```

## Secrets locaux Functions

Pour tester OpenAI localement, conserver la clé dans :

```text
functions/.secret.local
```

Ce fichier ne doit pas être commit.

## Commandes utiles

```bash
# Analyse Flutter
flutter analyze

# Tests Flutter
flutter test

# Tests Functions
npm test --prefix functions

# Build Functions TypeScript
npm run build --prefix functions

# Vérifier les changements git
git status
```

## Génération l10n

Le projet utilise `l10n.yaml` et les fichiers ARB sous `lib/l10n/`.

La génération est intégrée au workflow Flutter lorsque `generate: true` est configuré dans `pubspec.yaml`.

## Debug App Check

En debug, les providers debug sont utilisés automatiquement (`kDebugMode`).

Si Firebase Console demande l'enregistrement d'un token debug App Check, copier le token imprimé par la plateforme et l'ajouter dans la console Firebase.

## Bonnes pratiques locales

- Lancer `flutter analyze` avant tout commit.
- Lancer `flutter test` après modification UI ou ViewModel.
- Lancer `npm test --prefix functions` après modification backend.
- Ne pas modifier directement `firebase_options.dart` sauf régénération FlutterFire.
- Ne jamais commiter `.secret.local` ou des clés API.
