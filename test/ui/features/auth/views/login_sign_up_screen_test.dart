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
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/auth/views/login_sign_up_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows login form fields and sign up controls', (tester) async {
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(service: _SuccessfulAuthService()),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('auth-email-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('auth-password-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('auth-submit-button')), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);

    await tester.tap(find.text('S\'inscrire').first);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('auth-name-field')), findsOneWidget);
    expect(find.text('Créer un compte'), findsWidgets);
  });

  testWidgets('validates required fields and invalid email format', (
    tester,
  ) async {
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(service: _SuccessfulAuthService()),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Champ requis.'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const ValueKey('auth-email-field')),
      'not-an-email',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password-field')),
      'secret123',
    );
    await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Adresse e-mail invalide.'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(service: _SuccessfulAuthService()),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    EditableText passwordEditableText() {
      return tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const ValueKey('auth-password-field')),
          matching: find.byType(EditableText),
        ),
      );
    }

    expect(passwordEditableText().obscureText, isTrue);

    await tester.tap(
      find.byKey(const ValueKey('auth-password-visibility-button')),
    );
    await tester.pumpAndSettle();

    expect(passwordEditableText().obscureText, isFalse);
  });

  testWidgets('uses sign up autofill and name input hints', (tester) async {
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(service: _SuccessfulAuthService()),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    await tester.tap(find.text('S\'inscrire').first);
    await tester.pumpAndSettle();

    final nameField = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const ValueKey('auth-name-field')),
        matching: find.byType(EditableText),
      ),
    );
    final passwordField = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const ValueKey('auth-password-field')),
        matching: find.byType(EditableText),
      ),
    );

    expect(nameField.keyboardType, TextInputType.name);
    expect(nameField.textCapitalization, TextCapitalization.words);
    expect(passwordField.autofillHints, const [AutofillHints.newPassword]);
  });

  testWidgets('disables submit button while sign in is loading', (
    tester,
  ) async {
    final service = _CompleterAuthService();
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(service: service),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('auth-email-field')),
      'alex@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password-field')),
      'secret123',
    );
    await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
    await tester.pump();

    final button = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('auth-submit-button')),
    );
    expect(button.onPressed, isNull);

    service.complete(_account);
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error message when sign in fails', (tester) async {
    await tester.pumpWidget(
      _AuthTestApp(
        viewModel: AuthViewModel(
          authRepository: AuthRepository(
            service: _ThrowingAuthService(
              const AuthServiceException(code: 'user-not-found'),
            ),
          ),
          localDataStore: _FakeLocalDataStore(),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('auth-email-field')),
      'alex@example.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-password-field')),
      'secret123',
    );
    await tester.tap(find.byKey(const ValueKey('auth-submit-button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Aucun compte ne correspond à cette adresse e-mail.'),
      findsOneWidget,
    );
  });
}

class _AuthTestApp extends StatelessWidget {
  const _AuthTestApp({required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: viewModel,
      child: const MaterialApp(home: LoginSignUpScreen()),
    );
  }
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex@example.com',
  displayName: 'Alex Rivers',
);

class _SuccessfulAuthService implements AuthService {
  @override
  Stream<AuthAccount?> authStateChanges() => Stream<AuthAccount?>.value(null);

  @override
  AuthAccount? get currentAccount => null;

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

class _CompleterAuthService extends _SuccessfulAuthService {
  Completer<AuthAccount>? _completer;

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) {
    _completer = Completer<AuthAccount>();
    return _completer!.future;
  }

  void complete(AuthAccount account) {
    _completer?.complete(account);
  }
}

class _FakeLocalDataStore implements LocalDataStore {
  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}

  @override
  Future<bool> loadProfileNeedsPlanRegeneration() async => false;

  @override
  Future<void> saveProfileNeedsPlanRegeneration(bool value) async {}

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => {};

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async => [];

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}
}

class _ThrowingAuthService implements AuthService {
  const _ThrowingAuthService(this.error);

  final Object error;

  @override
  Stream<AuthAccount?> authStateChanges() => Stream<AuthAccount?>.value(null);

  @override
  AuthAccount? get currentAccount => null;

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    throw error;
  }

  @override
  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    throw error;
  }

  @override
  Future<void> signOut() async {}
}
