<div align="center">

# MealCrunchy

**AI-assisted meal planning for personalized nutrition workflows.**

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Functions%20%7C%20Firestore-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![OpenAI](https://img.shields.io/badge/OpenAI-Structured%20Outputs-412991?logo=openai&logoColor=white)](https://platform.openai.com)
[![Quality](https://img.shields.io/badge/147%20tests-0%20analyzer%20issues-brightgreen)]()

</div>

MealCrunchy is a Flutter mobile app that helps users move from a nutrition profile to a personalized 7-day meal plan, daily tracking, shopping list, and AI-assisted meal replacement. It is designed for people who want practical meal guidance without manually building every day of their plan. The project is interesting because it combines a product-ready Flutter experience with a secured Firebase backend for AI calls, quotas, validation, and observability.

## Highlights

- AI-generated 7-day meal plans.
- Meal replacement flow for individual meals.
- Firestore usage quotas for AI generation and replacements.
- Firebase App Check on backend-mediated AI requests.
- 147 tests and 0 analyzer issue.

## Table of contents

- [Screenshots](#screenshots)
- [What is implemented](#what-is-implemented)
- [Architecture decisions that matter](#architecture-decisions-that-matter)
- [Tech stack](#tech-stack)
- [Project structure](#project-structure)
- [Quick start](#quick-start)
- [Configuration / environment](#configuration--environment)
- [Quality and testing](#quality-and-testing)
- [Security notes](#security-notes)
- [Roadmap / current status](#roadmap--current-status)
- [License / author](#license--author)

## Screenshots

<div align="center">

| Onboarding | Dashboard | Meal plan |
|:---:|:---:|:---:|
| <img src="design-screenshots/Onboarding%20Goals.png" width="210" alt="MealCrunchy onboarding goals screen"/> | <img src="design-screenshots/Daily%20Meal%20Plan.png" width="210" alt="MealCrunchy daily meal plan dashboard"/> | <img src="design-screenshots/Meal%20Details.png" width="210" alt="MealCrunchy meal detail screen"/> |

| Meal replacement | Preferences / profile | Authentication |
|:---:|:---:|:---:|
| <img src="design-screenshots/Generating%20Plan.png" width="210" alt="MealCrunchy AI generation screen"/> | <img src="design-screenshots/Profile%20%26%20Preferences.png" width="210" alt="MealCrunchy profile and preferences screen"/> | <img src="design-screenshots/Login%20%26%20Sign%20Up.png" width="210" alt="MealCrunchy login and sign up screen"/> |

</div>

## What is implemented

- Email/password authentication with Firebase Auth and route guards.
- Nutrition onboarding covering goals, diet, allergies, activity level, and body metrics.
- AI-generated 7-day meal plan through Firebase Cloud Functions and OpenAI Structured Outputs.
- Meal replacement flow that preserves the active plan while swapping one selected meal.
- Daily dashboard with consumed-meal state, calories, and macro progress.
- Shopping list generated from the active meal plan.
- Profile and preference editing after onboarding.

## Architecture decisions that matter

- **API key security via backend proxy:** the OpenAI key stays in Firebase Functions and is never exposed to the Flutter client.
- **Structured Outputs validation:** AI responses are constrained and validated before being accepted by the app.
- **Non-blocking observability:** Crashlytics and Analytics are behind an injectable service; telemetry failure does not block the user flow.
- **Firestore quotas for abuse control:** monthly usage is reserved through backend-side Firestore transactions before expensive AI calls.
- **Local-first storage today, cloud sync later:** `LocalDataStore` abstracts persistence so the app can migrate from local storage to Firestore-backed sync without rewriting UI state.

## Tech stack

| Area | Stack |
|---|---|
| App | Flutter 3.44, Dart 3.12, Material 3 |
| State management | Provider, ChangeNotifier, ProxyProvider |
| Routing | GoRouter with route guards |
| Backend | Firebase Cloud Functions v2, TypeScript, Node.js 22 |
| AI | OpenAI Responses API, Structured Outputs |
| Firebase | Authentication, Firestore, App Check, Crashlytics, Analytics |
| Persistence | SharedPreferences behind an injectable `LocalDataStore` |
| Testing | `flutter_test`, Node.js `node:test`, `flutter analyze` |

## Project structure

```text
mealcrunchy/
|-- lib/
|   |-- main.dart                 # App entry point
|   |-- data/                     # Repositories and services
|   |-- domain/                   # Immutable models, JSON parsing, business types
|   |-- l10n/                     # Localization resources
|   `-- ui/                       # App shell, routing, theme, feature screens
|-- functions/
|   `-- src/                      # Firebase Functions proxy, quotas, validation
|-- test/                         # Flutter unit, widget, repository, and ViewModel tests
|-- docs/                         # Product, architecture, security, deployment, runbook
|-- design-screenshots/           # Reference screens used in this README
`-- firebase.json                 # Firebase and FlutterFire configuration
```

Useful documentation:

- [Product overview](docs/produit.md)
- [Technical architecture](docs/architecture.md)
- [AI backend and quotas](docs/backend-ia.md)
- [Security](docs/securite.md)
- [Local development](docs/developpement-local.md)
- [Quality and testing](docs/tests-qualite.md)

## Quick start

```bash
git clone https://github.com/cyril-belin/mealcrunchy.git
cd mealcrunchy
```

```bash
flutter pub get
npm install --prefix functions
```

Configure Firebase and the required secrets before using AI-related features.

```bash
flutter run
```

To run against local Functions emulators when configured:

```bash
flutter run --dart-define=USE_FUNCTIONS_EMULATOR=true
```

## Configuration / environment

MealCrunchy requires a Firebase project configured for the target platforms.

- Firebase Auth must be enabled for email/password sign-in.
- `lib/firebase_options.dart` is generated with FlutterFire CLI.
- AI features require a Firebase Functions secret named `OPENAI_API_KEY`.
- Local Functions development can use `functions/.secret.local`; it must not be committed.
- Web App Check requires a reCAPTCHA Enterprise site key passed with `APP_CHECK_RECAPTCHA_SITE_KEY`.
- Firestore is used server-side for monthly AI usage quotas.

Example setup commands:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
firebase functions:secrets:set OPENAI_API_KEY
```

## Quality and testing

The codebase is structured around maintainability: feature-oriented UI, injectable services, repository boundaries, typed ViewStates, and strict model validation.

Current validation status:

- 137 Flutter tests.
- 10 Firebase Functions tests.
- 147 tests total.
- `flutter analyze`: 0 issue.

Recommended checks before shipping changes:

```bash
flutter analyze
flutter test
npm test --prefix functions
```

## Security notes

- No OpenAI API key is exposed in the client.
- AI calls are mediated by Firebase Cloud Functions.
- Firebase App Check is enforced on expensive callable Functions.
- Monthly AI quotas are handled server-side with Firestore transactions.
- Firestore client rules are deny-all while quota data remains backend-managed.
- Input and output payloads are validated before use.

## Roadmap / current status

MealCrunchy is an advanced MVP with the core product loop implemented: onboarding, authentication, AI plan generation, daily tracking, shopping list, meal replacement, quotas, App Check, observability, and automated tests.

Current focus areas:

- Improve accessibility coverage across the main screens.
- Persist explicit theme choice instead of only following system settings.
- Prepare a future migration path from local-first storage to cloud sync.
- Continue hardening production deployment and operational runbooks.

## License / author

License information has not been published yet.

**Author:** Cyril Belin - [GitHub](https://github.com/cyril-belin)
