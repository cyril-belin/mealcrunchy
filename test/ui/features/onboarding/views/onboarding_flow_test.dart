import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/ui/app.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import '../../../../helpers/fake_local_data_store.dart';

void main() {
  testWidgets('navigates from goals to allergies and updates a selection', (
    tester,
  ) async {
    await tester.pumpWidget(_app(initialLocation: AppRoutes.onboardingGoals));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Manger plus sainement'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('option-Manger plus sainement-selected')),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(find.text('Continuer'), 320);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(find.text('Des allergies ou aversions ?'), findsOneWidget);
  });

  testWidgets('keeps metrics on screen when required values are missing', (
    tester,
  ) async {
    await tester.pumpWidget(_app(initialLocation: AppRoutes.onboardingMetrics));
    await tester.pumpAndSettle();

    expect(find.text('Renseignez vos mesures.'), findsNothing);

    final continueButton = find.byKey(
      const ValueKey('onboarding-metrics-continue'),
    );
    await tester.scrollUntilVisible(
      continueButton,
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('Renseignez vos mesures.'), findsOneWidget);
    expect(find.text('Creation de votre menu ideal...'), findsNothing);
  });

  testWidgets('records metrics and continues to generation after validation', (
    tester,
  ) async {
    await tester.pumpWidget(_app(initialLocation: AppRoutes.onboardingMetrics));
    await tester.pumpAndSettle();

    final ageField = find.byKey(const ValueKey('onboarding-age-field'));
    final heightField = find.byKey(const ValueKey('onboarding-height-field'));
    final currentWeightField = find.byKey(
      const ValueKey('onboarding-current-weight-field'),
    );
    final targetWeightField = find.byKey(
      const ValueKey('onboarding-target-weight-field'),
    );
    final continueButton = find.byKey(
      const ValueKey('onboarding-metrics-continue'),
    );

    await tester.enterText(ageField, '32');
    await tester.enterText(heightField, '181');
    await tester.scrollUntilVisible(
      currentWeightField,
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(currentWeightField, '82.5');
    await tester.enterText(targetWeightField, '86');
    await tester.scrollUntilVisible(
      continueButton,
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('Creation de votre menu ideal...'), findsOneWidget);
  });
}

MealCrunchyApp _app({required String initialLocation}) {
  return MealCrunchyApp(
    authRepository: AuthRepository(service: _AuthService()),
    localDataStore: FakeLocalDataStore(),
    initialLocation: initialLocation,
  );
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex@example.com',
  displayName: 'Alex Rivers',
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
