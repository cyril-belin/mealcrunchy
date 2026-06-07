import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/app.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/fake_local_data_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('renders the routed MealCrunchy app', (tester) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: _authRepository(account: null),
        localDataStore: FakeLocalDataStore(),
      ),
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
        localDataStore: FakeLocalDataStore()..activeMealPlan = _mealPlan,
        initialLocation: AppRoutes.mealDetailsFor('ai-breakfast'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Petit-dejeuner IA'), findsOneWidget);
    expect(find.text('410 kcal'), findsOneWidget);
    expect(find.text('32g'), findsOneWidget);
    expect(find.text('36g'), findsOneWidget);

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
        localDataStore: FakeLocalDataStore(),
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
        localDataStore: FakeLocalDataStore(),
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
        localDataStore: FakeLocalDataStore()..activeMealPlan = _mealPlan,
        initialLocation: AppRoutes.mealDetailsFor('ai-breakfast'),
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

final _mealPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_aiBreakfast],
    ),
  ),
  summary: const NutritionSummary(
    consumedCalories: 0,
    targetCalories: 2100,
    progress: 0,
    proteinPercent: 32,
    carbsPercent: 43,
    fatPercent: 25,
  ),
);

const _aiBreakfast = Meal(
  id: 'ai-breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Petit-dejeuner IA',
  calories: 410,
  protein: 32,
  carbs: 36,
  fat: 14,
  imagePrompt: 'ai breakfast',
  duration: '15 min',
  ingredients: ['Ingredient IA'],
  instructions: ['Instruction IA'],
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
