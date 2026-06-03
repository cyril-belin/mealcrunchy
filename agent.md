# MealCrunchy Agent Reference

MealCrunchy is a Flutter meal planning app scaffolded from `design-agent-prompt.md`
and the PNG references in `design-screenshots/`. This document is the root
reference for future Codex conversations.

## Stack

- Flutter with Material 3.
- `go_router` for declarative navigation and deep-link-ready route paths.
- `provider` for dependency injection and `ChangeNotifier` ViewModels.
- Static design seed data only. No business features, persistence, AI calls, or
  real authentication behavior are implemented yet.
- Prototype interactions are allowed: local UI selection state, text input,
  navigation, visual toggles, and snackbars that explain unconnected actions.

## Architecture

Follow the local skills:

- `flutter-apply-architecture-best-practices`
- `flutter-setup-declarative-routing`

Architecture rules:

- Use MVVM in the UI layer.
- Views stay lean and render state from ViewModels.
- ViewModels extend `ChangeNotifier`, expose immutable/read-only state, and
  receive repositories through constructors.
- Repositories are the single source of truth for UI-facing domain models.
- Services wrap raw/static/external data access.
- Domain models are clean app models and do not depend on Flutter.
- Data flows one way: Service -> Repository -> ViewModel -> View.

## Folder Structure

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
    │   ├── theme/
    │   └── widgets/
    └── features/
        ├── auth/
        ├── meal_plan/
        ├── onboarding/
        ├── profile/
        └── splash/
```

## Routing

Routes live in `lib/ui/core/routing/`.

- `AppRoutes` stores path constants and path helpers.
- `appRouter` is the single `GoRouter` configuration.
- `main.dart` calls `usePathUrlStrategy()` before running the app.
- `MealCrunchyApp` binds the router with `MaterialApp.router`.

Current route map:

- `/` -> Splash
- `/auth` -> Login and Sign Up
- `/onboarding/goals` -> Goals and dietary preferences
- `/onboarding/allergies` -> Allergies and dislikes
- `/onboarding/activity` -> Activity and meal timing
- `/onboarding/metrics` -> Body metrics
- `/generating-plan` -> Generating plan
- `/meal-plan` -> Daily meal plan
- `/meal-plan/:mealId` -> Meal details
- `/profile` -> Profile and preferences

## UI Conventions

- Shared visual primitives live in `lib/ui/core/widgets/`.
- Theme tokens live in `lib/ui/core/theme/` and mirror the exported design:
  greens, white surfaces, light neutrals, accent orange, soft shadows, rounded
  cards, and readable typography.
- Screens are design integrations with minimum prototype interactivity. Controls
  should react locally even when the underlying business behavior is not built.
- Buttons that are not connected to a real feature should show clear prototype
  feedback instead of doing nothing.
- Prefer adding shared UI components only when two or more screens need the same
  pattern.

## Development Rules

- Use MCP Dart/Flutter tools for pub operations, analysis, tests, and formatting.
- Do not add business functionality in architecture/setup conversations, but keep
  prototype screens interactable enough to exercise the flow.
- Implement future features one conversation at a time.
- For each feature, preserve the layer boundaries above before adding behavior.
