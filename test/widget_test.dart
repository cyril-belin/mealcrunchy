import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/ui/app.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('renders the routed MealCrunchy app', (tester) async {
    await tester.pumpWidget(
      MealCrunchyApp(authRepository: _authRepository(account: null)),
    );
    await tester.pumpAndSettle();

    expect(find.text('MealCrunchy'), findsOneWidget);
    expect(
      find.text('Votre guide nutritionnel propulsé par l\'IA'),
      findsOneWidget,
    );
    expect(find.text('Commencer'), findsOneWidget);
  });

  testWidgets('meal detail back button falls back to the meal plan route', (
    tester,
  ) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: _authRepository(account: _account),
        initialLocation: AppRoutes.mealDetailsFor('avocado-toast'),
      ),
    );
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
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: _authRepository(account: null),
        initialLocation: AppRoutes.auth,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Nom complet'), findsNothing);

    await tester.tap(find.text('S\'inscrire').first);
    await tester.pumpAndSettle();

    expect(find.text('Nom complet'), findsOneWidget);
    expect(find.text('Créer un compte'), findsWidgets);
  });

  testWidgets('onboarding goal cards can be selected', (tester) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: _authRepository(account: _account),
        initialLocation: AppRoutes.onboardingGoals,
      ),
    );
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

  testWidgets('meal detail stays read-only without prototype session actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: _authRepository(account: _account),
        initialLocation: AppRoutes.mealDetailsFor('avocado-toast'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    expect(find.text('Marquer comme mange'), findsNothing);
    expect(
      find.text('Repas marque comme mange pour cette session.'),
      findsNothing,
    );
  });
}

AuthRepository _authRepository({required AuthAccount? account}) {
  return AuthRepository(service: _AuthService(account: account));
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex@example.com',
  displayName: 'Alex Rivers',
);

class _AuthService implements AuthService {
  const _AuthService({required this.account});

  final AuthAccount? account;

  @override
  Stream<AuthAccount?> authStateChanges() =>
      Stream<AuthAccount?>.value(account);

  @override
  AuthAccount? get currentAccount => account;

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    return account ?? _account;
  }

  @override
  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return account ?? _account;
  }

  @override
  Future<void> signOut() async {}
}
