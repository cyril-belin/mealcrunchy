import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/app.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  testWidgets('renders account and saved profile preferences', (tester) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: AuthRepository(service: _AuthService()),
        localDataStore: FakeLocalDataStore()
          ..userProfile = _profile
          ..activeMealPlan = _mealPlan,
        initialLocation: AppRoutes.profile,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Alex Martin'), findsOneWidget);
    expect(find.text('alex.martin@example.com'), findsOneWidget);
    expect(find.text('82.5 kg'), findsOneWidget);
    expect(find.text('76.0 kg'), findsOneWidget);
    expect(find.text('1850'), findsOneWidget);
    expect(find.text('Perdre du poids'), findsOneWidget);
    expect(find.text('Méditerranéen'), findsOneWidget);
    expect(find.text('Cacahuètes - Olives'), findsOneWidget);
    expect(find.text('Modifier'), findsOneWidget);
    expect(find.text('Notifications'), findsNothing);
    expect(find.text('Centre d\'aide'), findsNothing);
  });

  testWidgets('shows regeneration banner and opens prefilled onboarding edit', (
    tester,
  ) async {
    await tester.pumpWidget(
      MealCrunchyApp(
        authRepository: AuthRepository(service: _AuthService()),
        localDataStore: FakeLocalDataStore()
          ..userProfile = _profile
          ..activeMealPlan = _mealPlan
          ..profileNeedsPlanRegeneration = true,
        initialLocation: AppRoutes.profile,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Plan à régénérer'), findsOneWidget);
    expect(find.text('Régénérer le plan'), findsOneWidget);

    await tester.tap(find.text('Modifier'));
    await tester.pumpAndSettle();

    expect(find.text('Quel est votre objectif ?'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('option-Perdre du poids-selected')),
      findsOneWidget,
    );
  });
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex.martin@example.com',
  displayName: 'Alex Martin',
);

const _profile = UserProfile(
  goal: NutritionGoal.loseWeight,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Cacahuètes'],
  customAversions: ['Olives'],
  activityLevel: ActivityLevel.moderatelyActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

final _mealPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  summary: const NutritionSummary(
    consumedCalories: 0,
    targetCalories: 1850,
    progress: 0,
    proteinPercent: 30,
    carbsPercent: 45,
    fatPercent: 25,
  ),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_meal],
    ),
  ),
);

const _meal = Meal(
  id: 'meal-1',
  type: 'DEJEUNER',
  name: 'Bowl énergie',
  calories: 520,
  protein: 36,
  carbs: 48,
  fat: 18,
  imagePrompt: 'healthy bowl',
  duration: '20 min',
  ingredients: ['Riz complet'],
  instructions: ['Assembler'],
);

class _AuthService implements AuthService {
  @override
  Stream<AuthAccount?> authStateChanges() =>
      Stream<AuthAccount?>.value(_account);

  @override
  AuthAccount? get currentAccount => _account;

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    return _account;
  }

  @override
  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _account;
  }

  @override
  Future<void> signOut() async {}
}
