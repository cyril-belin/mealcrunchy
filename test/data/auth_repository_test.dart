import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';

void main() {
  group('AuthRepository', () {
    test('signs in with email and password', () async {
      final repository = AuthRepository(service: _SuccessfulAuthService());

      final account = await repository.signIn(
        email: 'alex@example.com',
        password: 'secret123',
      );

      expect(account.uid, 'user-1');
      expect(account.email, 'alex@example.com');
    });

    test('creates an account with a display name', () async {
      final service = _SuccessfulAuthService();
      final repository = AuthRepository(service: service);

      final account = await repository.signUp(
        email: 'alex@example.com',
        password: 'secret123',
        displayName: 'Alex Rivers',
      );

      expect(account.displayName, 'Alex Rivers');
      expect(service.lastDisplayName, 'Alex Rivers');
    });

    test('maps an auth service error to a French readable message', () async {
      final repository = AuthRepository(
        service: _ThrowingAuthService(
          const AuthServiceException(code: 'email-already-in-use'),
        ),
      );

      expect(
        () => repository.signIn(
          email: 'alex@example.com',
          password: 'bad-password',
        ),
        throwsA(
          isA<AuthRepositoryException>().having(
            (error) => error.message,
            'message',
            'Cette adresse e-mail est déjà utilisée.',
          ),
        ),
      );
    });
  });
}

const _account = AuthAccount(
  uid: 'user-1',
  email: 'alex@example.com',
  displayName: 'Alex Rivers',
);

class _SuccessfulAuthService implements AuthService {
  String? lastDisplayName;

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
    lastDisplayName = displayName;
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
