import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/core/routing/app_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_theme.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('keeps unauthenticated users on the splash route', (
    tester,
  ) async {
    final authViewModel = AuthViewModel(
      authRepository: AuthRepository(service: _AuthService(account: null)),
      localDataStore: _FakeLocalDataStore(),
    );
    final router = createAppRouter(authViewModel: authViewModel);

    router.go(AppRoutes.splash);
    await tester.pumpWidget(
      _RouterTestApp(router: router, authViewModel: authViewModel),
    );
    await tester.pumpAndSettle();

    expect(find.text('MealCrunchy'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.byKey(const ValueKey('auth-email-field')), findsNothing);
  });

  testWidgets('redirects unauthenticated users from private routes to auth', (
    tester,
  ) async {
    final authViewModel = AuthViewModel(
      authRepository: AuthRepository(service: _AuthService(account: null)),
      localDataStore: _FakeLocalDataStore(),
    );
    final router = createAppRouter(authViewModel: authViewModel);

    router.go(AppRoutes.mealPlan);
    await tester.pumpWidget(
      _RouterTestApp(router: router, authViewModel: authViewModel),
    );
    await tester.pumpAndSettle();

    expect(find.text('MealCrunchy'), findsOneWidget);
    expect(find.byKey(const ValueKey('auth-email-field')), findsOneWidget);
  });

  testWidgets(
    'redirects authenticated users without meal plan from splash to onboarding',
    (tester) async {
      final authViewModel = AuthViewModel(
        authRepository:
            AuthRepository(service: _AuthService(account: _account)),
        localDataStore: _FakeLocalDataStore(hasMealPlan: false),
      );
      final router = createAppRouter(authViewModel: authViewModel);

      router.go(AppRoutes.splash);
      await tester.pumpWidget(
        _RouterTestApp(router: router, authViewModel: authViewModel),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quel est votre objectif ?'), findsOneWidget);
    },
  );

  testWidgets(
    'redirects authenticated users with meal plan from splash to meal plan',
    (tester) async {
      final authViewModel = AuthViewModel(
        authRepository:
            AuthRepository(service: _AuthService(account: _account)),
        localDataStore: _FakeLocalDataStore(hasMealPlan: true),
      );
      final router = createAppRouter(authViewModel: authViewModel);

      router.go(AppRoutes.splash);
      await tester.pumpWidget(
        _RouterTestApp(router: router, authViewModel: authViewModel),
      );
      await tester.pumpAndSettle();

      expect(find.text('Votre plan IA'), findsOneWidget);
    },
  );

  testWidgets(
    'redirects authenticated users without meal plan from auth to onboarding',
    (tester) async {
      final authViewModel = AuthViewModel(
        authRepository:
            AuthRepository(service: _AuthService(account: _account)),
        localDataStore: _FakeLocalDataStore(hasMealPlan: false),
      );
      final router = createAppRouter(authViewModel: authViewModel);

      router.go(AppRoutes.auth);
      await tester.pumpWidget(
        _RouterTestApp(router: router, authViewModel: authViewModel),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quel est votre objectif ?'), findsOneWidget);
    },
  );
}

class _RouterTestApp extends StatelessWidget {
  const _RouterTestApp({required this.router, required this.authViewModel});

  final RouterConfig<Object> router;
  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(localDataStore: _FakeLocalDataStore()),
        ),
      ],
      child: MaterialApp.router(
        title: 'MealCrunchy',
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex@example.com',
  displayName: 'Alex Rivers',
);

class _AuthService implements AuthService {
  _AuthService({required this.account});

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

class _FakeLocalDataStore implements LocalDataStore {
  _FakeLocalDataStore({this.hasMealPlan = false});

  final bool hasMealPlan;

  @override
  Future<MealPlan?> loadActiveMealPlan() async =>
      hasMealPlan ? _stubMealPlan() : null;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => {};

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async => [];

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}
}

MealPlan _stubMealPlan() {
  return MealPlan.fromJson({
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'summary': {
      'consumedCalories': 0,
      'targetCalories': 2000,
      'progress': 0.0,
      'proteinPercent': 30,
      'carbsPercent': 50,
      'fatPercent': 20,
    },
    'days': List.generate(
      7,
      (i) => {
        'id': 'day-$i',
        'label': 'Jour ${i + 1}',
        'meals': [
          {
            'id': 'meal-$i',
            'name': 'Repas test',
            'type': 'DEJEUNER',
            'calories': 500,
            'protein': 30,
            'carbs': 50,
            'fat': 15,
            'duration': '20 min',
            'ingredients': ['Ingredient 1'],
            'instructions': ['Etape 1'],
          },
        ],
      },
    ),
  });
}
