# MealCrunchy

MealCrunchy est une application mobile Flutter de nutrition personnalisée pensée autour d'un workflow **design-first** et **AI-assisted**. Les écrans ont été conçus avec FlutterFlow Designer à partir d'un prompt, exportés en visuels et en Markdown agent-ready, puis utilisés comme base pour l'implémentation Flutter orchestrée via LLM.

## Aperçu

L'application guide l'utilisateur dans un parcours de personnalisation nutritionnelle avec onboarding, définition d'objectif, préférences alimentaires, niveau d'activité, génération d'un plan repas par IA, et consultation détaillée des repas. Le projet met aussi l'accent sur une architecture propre, une cohérence UI, et une boucle d'amélioration review → plan → implémentation → tests.

## Fonctionnalités

- Onboarding et parcours de personnalisation utilisateur
- Définition de l'objectif nutritionnel
- Sélection des allergies, préférences et habitudes alimentaires
- Génération d'un plan repas assisté par IA
- Dashboard quotidien avec objectifs et macros
- Consultation détaillée des repas, ingrédients et instructions

## Workflow de création

1. Génération des écrans avec FlutterFlow Designer depuis un prompt produit
2. Export des écrans en images et du contexte en Markdown agent-ready
3. Transmission du design exporté à un LLM pour l'implémentation Flutter
4. Revue de code structurée pour identifier les axes d'amélioration
5. Formalisation des corrections dans un fichier `.md`, génération d'un plan, validation, puis implémentation avec tests
6. Approche feature-by-feature avec isolation du contexte et contrôle de non-régression

## Architecture

Le projet suit une architecture MVVM avec séparation claire entre Service, Repository, ViewModel et View. L'utilisation de Provider et de `ChangeNotifierProxyProvider` permet de chaîner proprement les dépendances et de conserver une base structurée pour faire évoluer l'application.

## Design

Le design de l'application a été storyboardé dans FlutterFlow Designer, qui permet de générer des écrans depuis un prompt, d'itérer dessus, puis d'exporter les résultats en PNG ou en agent prompt Markdown. Cette approche a permis de piloter non seulement l'UI, mais aussi l'ordre des écrans et le parcours produit.

## Localisation

L'interface initialement générée en anglais a été ensuite adaptée en français. À terme, l'étape suivante consiste à passer vers une vraie stratégie d'internationalisation Flutter avec `flutter_localizations`, `intl` et fichiers ARB pour une gestion propre des locales.

## Qualité du code

La base actuelle a été évaluée comme propre, mature et bien structurée, avec plusieurs points forts relevés sur l'architecture, l'immutabilité, le design system et la discipline de prototype. Les axes d'amélioration identifiés concernent surtout le passage à une base plus production-ready : gestion asynchrone explicite, typage plus fort, accessibilité, i18n et règles de lint plus strictes.

## Stack technique

- Flutter
- Provider
- Architecture MVVM
- FlutterFlow Designer pour le storyboarding UI
- Workflow d'implémentation assisté par LLM

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Structure du repo

```text
lib/
├── data/
│   ├── repositories/
│   └── services/
├── domain/
│   └── models/
└── ui/
    ├── app.dart
    ├── core/
    │   ├── routing/
    │   ├── state/
    │   ├── theme/
    │   └── widgets/
    └── features/
        ├── auth/
        ├── meal_plan/
        ├── onboarding/
        ├── profile/
        └── splash/
```

## Captures d'écran

Ajouter ici les captures principales du projet :
- écran d'accueil
- onboarding
- objectif
- allergies
- plan IA
- détail repas

## À venir

- Renforcement de l'état asynchrone des ViewModels
- Internationalisation propre avec ARB
- Amélioration de l'accessibilité
- Ajout et extension des tests
- Développement incrémental par fonctionnalité avec documentation `.md` dédiée

## Positionnement du projet

MealCrunchy est à la fois une application Flutter et un exemple de workflow **design-to-code orchestré par IA**, combinant conception d'écrans, structuration du parcours utilisateur, implémentation assistée, revue, planification et tests.
