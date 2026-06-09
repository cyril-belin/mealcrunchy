<div align="center">

# MealCrunchy

**Application mobile de nutrition personnalisée par IA**

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Functions-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![OpenAI](https://img.shields.io/badge/OpenAI-Structured%20Outputs-412991?logo=openai&logoColor=white)](https://platform.openai.com)
[![Tests](https://img.shields.io/badge/tests-147%20passing-brightgreen)]()

</div>

---

MealCrunchy est une application Flutter multiplateforme qui accompagne l'utilisateur dans son parcours nutritionnel : de l'onboarding personnalisé au plan repas 7 jours, en passant par le suivi quotidien des calories et macronutriments. Le plan repas est personnalisable via un proxy Firebase Cloud Functions qui interroge l'API OpenAI avec Structured Outputs.

<div align="center">

| Splash | Onboarding | Dashboard | Detail repas |
|:---:|:---:|:---:|:---:|
| <img src="design-screenshots/Splash%20Screen.png" width="180"/> | <img src="design-screenshots/Onboarding%20Goals.png" width="180"/> | <img src="design-screenshots/Daily%20Meal%20Plan.png" width="180"/> | <img src="design-screenshots/Meal%20Details.png" width="180"/> |

| Login | Allergies | Mensurations | Profil |
|:---:|:---:|:---:|:---:|
| <img src="design-screenshots/Login%20%26%20Sign%20Up.png" width="180"/> | <img src="design-screenshots/Onboarding%20Allergies.png" width="180"/> | <img src="design-screenshots/Onboarding%20Metrics.png" width="180"/> | <img src="design-screenshots/Profile%20%26%20Preferences.png" width="180"/> |

</div>

---

## Fonctionnalites

Documentation complète : [docs/README.md](docs/README.md)

| Domaine | Description | Statut |
|---|---|:---:|
| Authentification | Inscription et connexion email/password via Firebase Auth, route guards | Done |
| Onboarding | Parcours multi-etapes : objectif, regime, allergies, activite, mensurations | Done |
| Stockage local | Persistance du profil, du plan actif et du suivi quotidien via SharedPreferences | Done |
| Proxy IA | Firebase Cloud Functions (TypeScript) avec OpenAI Structured Outputs, validation entree/sortie | Done |
| Dashboard quotidien | Plan du jour, checkbox repas consommes, progression calories et macros en temps reel | Done |
| Detail repas | Fiche complete : type, duree, calories, macros, ingredients, instructions | Done |
| Generation plan IA | Plan repas 7 jours personnalise genere par le proxy OpenAI | Done |
| Remplacement repas | Remplacer un repas par une alternative IA respectant le profil | Done |
| Liste de courses | Liste d'ingredients generee depuis le plan actif, avec cases a cocher | Done |
| Profil et preferences | Consultation et modification du profil nutritionnel apres onboarding | Done |
| Quotas IA | Quotas mensuels par utilisateur (transaction Firestore), affichage du restant | Done |
| Securite | Firebase App Check (Play Integrity / App Attest / reCAPTCHA), regles Firestore deny-all | Done |
| Observabilite | Crashlytics (crashs) et Analytics (events IA, navigation) derriere une abstraction injectable | Done |
| Internationalisation | `flutter_localizations` + `intl`, formats de dates localises (fr-FR) | Done |
| Theme | Material 3, themes clair et sombre suivant le systeme | Done |

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                        UI Layer                         │
│  View (StatelessWidget) ←→ ViewModel (ChangeNotifier)   │
├─────────────────────────────────────────────────────────┤
│                      Data Layer                         │
│  Repository ←→ Service / LocalDataStore                 │
├─────────────────────────────────────────────────────────┤
│                     Domain Layer                        │
│  Immutable Models  ·  JSON serialization  ·  Typesafe   │
├─────────────────────────────────────────────────────────┤
│                   Backend (serverless)                   │
│  Firebase Cloud Functions (TypeScript)  →  OpenAI API   │
│  App Check  ·  Quotas Firestore  ·  Secrets manager     │
└─────────────────────────────────────────────────────────┘
```

- **MVVM** avec `Provider` / `ChangeNotifierProxyProvider` pour l'injection de dependances et le chainage reactif.
- **ViewState** (`ViewLoading`, `ViewError`, `ViewData`) pour gerer les etats asynchrones de chaque ecran de maniere exhaustive via `switch` expressions.
- **GoRouter** pour la navigation declarative avec route guards et deep linking.
- **LocalDataStore** abstrait (interface injectable) : persistance via `SharedPreferencesAsync`, facilement remplacable par un faux store en test.
- **AiProxyService** isole le backend IA derriere une abstraction `AiCallableClient` injectable, zero couplage Firebase dans les tests.
- **ObservabilityService** abstrait Crashlytics et Analytics : implementation `Firebase` en prod, `Noop` en test, aucun blocage de l'app si la telemetrie echoue.
- **App Check** applique cote serveur (`enforceAppCheck`) et active cote client par plateforme, pour proteger les Functions IA couteuses contre l'abus.

## Stack technique

| Categorie | Technologies |
|---|---|
| **Frontend** | Flutter 3.44 · Dart 3.12 · Provider · GoRouter · Material 3 (clair/sombre) |
| **Backend** | Firebase Cloud Functions v2 (TypeScript) · OpenAI Responses API |
| **Auth & Securite** | Firebase Authentication (email/password) · App Check · regles Firestore deny-all |
| **Quotas** | Transactions Firestore (Admin SDK) · quotas mensuels par utilisateur |
| **Observabilite** | Firebase Crashlytics · Firebase Analytics |
| **i18n** | `flutter_localizations` · `intl` (fr-FR) |
| **Persistance** | SharedPreferences (profil, plan actif, suivi quotidien, liste de courses) |
| **Design** | Plus Jakarta Sans · Design system tokens (couleurs, typographie, composants) |
| **Tests** | `flutter_test` (137 tests) · Node.js `node:test` (10 tests Functions) |
| **CI/Qualite** | `flutter analyze` (0 issue) · lint strict · revue de code systematique |

## Demarrage rapide

### Prerequis

- Flutter SDK >= 3.44
- Dart SDK >= 3.12
- Node.js >= 22 (pour les Firebase Functions)
- Un projet Firebase configure avec Authentication active

### Installation

```bash
# Cloner le depot
git clone https://github.com/cyril-belin/mealcrunchy.git
cd mealcrunchy

# Installer les dependances Flutter
flutter pub get

# Installer les dependances Functions
npm install --prefix functions

# Lancer l'application
flutter run
```

### Lancer les tests

```bash
# Tests Flutter (137 tests)
flutter test

# Analyse statique (0 issue)
flutter analyze

# Tests Firebase Functions (10 tests)
npm test --prefix functions
```

## Structure du projet

```text
mealcrunchy/
├── lib/
│   ├── main.dart                        # Point d'entree
│   ├── data/
│   │   ├── repositories/               # Acces aux donnees (MealPlan, Preferences, Auth)
│   │   └── services/                   # Sources (StaticContent, LocalDataStore, AiProxy, Auth)
│   ├── domain/
│   │   └── models/                     # Modeles immuables avec fromJson/toJson
│   └── ui/
│       ├── app.dart                    # Configuration providers et routeur
│       ├── core/                       # Routing, theme, state (ViewState), widgets partages
│       └── features/                   # Ecrans par domaine (auth, onboarding, meal_plan, profile)
├── functions/
│   └── src/                            # Cloud Functions TypeScript (proxy OpenAI)
├── test/                               # Tests unitaires, widget et integration
├── design-screenshots/                 # Maquettes de reference
└── docs/fonctionnalites/               # Specs et suivi par fonctionnalite
```

## Decisions techniques

| Decision | Justification |
|---|---|
| `SharedPreferences` plutot que SQLite/Hive | Suffisant pour le MVP ; interface abstraite permettant de migrer sans casser l'existant |
| Proxy Firebase plutot qu'appel direct OpenAI | Securite : la cle API ne quitte jamais le serveur ; validation stricte des reponses IA |
| Structured Outputs (json_schema strict) | Garantit un format de reponse conforme cote IA, evite le parsing fragile |
| App Check + quotas mensuels Firestore | Protege les Functions IA couteuses contre l'abus ; reservation avant appel, liberation en cas d'echec |
| Observabilite derriere une abstraction | Crashlytics/Analytics injectables ; un echec de telemetrie ne bloque jamais l'experience |
| `ChangeNotifier` + `Provider` | Simple, natif Flutter, suffisant pour l'echelle actuelle ; migration vers Riverpod possible sans refonte |

## Methodologie

Le projet suit un workflow **design-first** et **feature-by-feature** :

1. **Design** — Maquettes generees via FlutterFlow Designer, exportees en PNG et en prompts Markdown.
2. **Specification** — Chaque fonctionnalite possede un fichier `.md` dedie (perimetre, regles, tests, etapes).
3. **Implementation** — Une seule fonctionnalite active a la fois, avec isolation du contexte.
4. **Tests** — Ecrits avant ou avec le code ; validation systematique (`flutter test`, `flutter analyze`).
5. **Revue** — Code review structuree, identification des points d'attention, correction et retest.
6. **Documentation** — Chaque erreur, resolution et validation est tracee dans le fichier de fonctionnalite.

## Roadmap

- [x] Generation du plan repas 7 jours via le proxy IA
- [x] Remplacement d'un repas individuel par une alternative IA
- [x] Liste de courses generee depuis le plan actif
- [x] Ecran profil et preferences modifiables
- [x] Gestion des quotas IA (quotas mensuels, transactions Firestore)
- [x] Internationalisation (`flutter_localizations` / `intl`)
- [x] Securite App Check et observabilite (Crashlytics / Analytics)
- [x] Theme sombre (Material 3)
- [ ] Amelioration de l'accessibilite (semantics, contrastes)
- [ ] Persistance du choix de theme (clair / sombre / systeme)

## Auteur

**Cyril Belin** — [GitHub](https://github.com/cyril-belin)
