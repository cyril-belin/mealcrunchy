import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/ui/app.dart';
import 'package:mealcrunchy/ui/core/routing/app_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';

void main() {
  testWidgets('renders the routed MealCrunchy app', (tester) async {
    appRouter.go(AppRoutes.splash);
    await tester.pumpWidget(const MealCrunchyApp());

    expect(find.text('MealCrunchy'), findsOneWidget);
    expect(
      find.text('Votre guide nutritionnel propulse par l\'IA'),
      findsOneWidget,
    );
  });

  testWidgets('meal detail back button falls back to the meal plan route', (
    tester,
  ) async {
    appRouter.go(AppRoutes.splash);
    await tester.pumpWidget(const MealCrunchyApp());

    appRouter.go(AppRoutes.mealDetailsFor('avocado-toast'));
    await tester.pumpAndSettle();

    expect(find.text('Toast avocat et oeuf'), findsOneWidget);
    expect(find.text('340 kcal'), findsOneWidget);
    expect(find.text('24g'), findsOneWidget);
    expect(find.text('20g'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Repas prevus'), findsOneWidget);
  });

  testWidgets('auth screen switches between login and sign up modes', (
    tester,
  ) async {
    appRouter.go(AppRoutes.auth);
    await tester.pumpWidget(const MealCrunchyApp());
    await tester.pumpAndSettle();

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Nom complet'), findsNothing);

    await tester.tap(find.text('S\'inscrire').first);
    await tester.pumpAndSettle();

    expect(find.text('Nom complet'), findsOneWidget);
    expect(find.text('Creer un compte'), findsWidgets);
  });

  testWidgets('onboarding goal cards can be selected', (tester) async {
    appRouter.go(AppRoutes.onboardingGoals);
    await tester.pumpWidget(const MealCrunchyApp());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('option-Perdre du poids-selected')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('option-Prendre du muscle-selected')),
      findsNothing,
    );

    await tester.tap(find.text('Prendre du muscle'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('option-Perdre du poids-selected')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('option-Prendre du muscle-selected')),
      findsOneWidget,
    );
  });

  testWidgets('meal detail prototype actions give visible feedback', (
    tester,
  ) async {
    appRouter.go(AppRoutes.mealDetailsFor('avocado-toast'));
    await tester.pumpWidget(const MealCrunchyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Marquer comme mange'), 400);
    await tester.tap(find.text('Marquer comme mange'));
    await tester.pump();

    expect(
      find.text('Repas marque comme mange pour cette session.'),
      findsOneWidget,
    );
  });
}
