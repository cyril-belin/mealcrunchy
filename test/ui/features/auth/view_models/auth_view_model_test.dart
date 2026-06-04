import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';

void main() {
  group('AuthViewModel', () {
    test('sets loading then data after sign in succeeds', () async {
      final viewModel = AuthViewModel(
        authRepository: AuthRepository(service: _SuccessfulAuthService()),
      );
      final states = <ViewState<AuthAccount?>>[];
      viewModel.addListener(() => states.add(viewModel.authState));

      await viewModel.signIn(email: 'alex@example.com', password: 'secret123');

      expect(states.first, isA<ViewLoading<AuthAccount?>>());
      expect(viewModel.authState, isA<ViewData<AuthAccount?>>());
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isAuthenticated, isTrue);
    });

    test('sets loading then error after sign in fails', () async {
      final viewModel = AuthViewModel(
        authRepository: AuthRepository(
          service: _ThrowingAuthService(
            const AuthServiceException(code: 'invalid-email'),
          ),
        ),
      );
      final states = <ViewState<AuthAccount?>>[];
      viewModel.addListener(() => states.add(viewModel.authState));

      await viewModel.signIn(email: 'not-an-email', password: 'secret123');

      expect(states.first, isA<ViewLoading<AuthAccount?>>());
      expect(viewModel.authState, isA<ViewError<AuthAccount?>>());
      expect(viewModel.errorMessage, 'Adresse e-mail invalide.');
      expect(viewModel.isAuthenticated, isFalse);
    });

    test('updates state when the account display name changes', () async {
      final service = _StreamingAuthService(
        currentAccount: const AuthAccount(
          uid: 'user-1',
          email: 'alex@example.com',
          displayName: 'Alex Rivers',
        ),
      );
      final viewModel = AuthViewModel(
        authRepository: AuthRepository(service: service),
      );
      final states = <ViewState<AuthAccount?>>[];
      viewModel.addListener(() => states.add(viewModel.authState));

      service.emit(
        const AuthAccount(
          uid: 'user-1',
          email: 'alex@example.com',
          displayName: 'Alex Martin',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(states, hasLength(1));
      expect(
        (viewModel.authState as ViewData<AuthAccount?>).data?.displayName,
        'Alex Martin',
      );

      await viewModel.disposeLater();
    });
  });
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

class _StreamingAuthService implements AuthService {
  _StreamingAuthService({required this._currentAccount});

  final _controller = StreamController<AuthAccount?>();
  AuthAccount? _currentAccount;

  void emit(AuthAccount? account) {
    _currentAccount = account;
    _controller.add(account);
  }

  @override
  Stream<AuthAccount?> authStateChanges() => _controller.stream;

  @override
  AuthAccount? get currentAccount => _currentAccount;

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    return _currentAccount ?? _account;
  }

  @override
  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _currentAccount ?? _account;
  }

  @override
  Future<void> signOut() async {
    emit(null);
  }
}

extension on AuthViewModel {
  Future<void> disposeLater() async {
    dispose();
    await Future<void>.delayed(Duration.zero);
  }
}
