import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';

abstract class AuthService {
  AuthAccount? get currentAccount;

  Stream<AuthAccount?> authStateChanges();

  Future<AuthAccount> signIn({required String email, required String password});

  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({this.firebaseAuth, this.firebaseAuthProvider});

  final FirebaseAuth? firebaseAuth;
  final FirebaseAuth Function()? firebaseAuthProvider;

  FirebaseAuth get _auth {
    try {
      return firebaseAuth ??
          firebaseAuthProvider?.call() ??
          FirebaseAuth.instance;
    } on FirebaseException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    }
  }

  @override
  AuthAccount? get currentAccount => _auth.currentUser?.toAuthAccount();

  @override
  Stream<AuthAccount?> authStateChanges() =>
      _auth.authStateChanges().map((user) => user?.toAuthAccount());

  @override
  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _accountFromCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    } on FirebaseException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    }
  }

  @override
  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      final trimmedName = displayName.trim();
      if (user != null && trimmedName.isNotEmpty) {
        await user.updateDisplayName(trimmedName);
      }
      return (user ?? credential.user)?.toAuthAccount(
            displayName: trimmedName,
          ) ??
          _accountFromCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    } on FirebaseException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    } on FirebaseException catch (error) {
      throw AuthServiceException(code: error.code, message: error.message);
    }
  }

  AuthAccount _accountFromCredential(UserCredential credential) {
    final user = credential.user;
    if (user == null) {
      throw const AuthServiceException(code: 'missing-user');
    }
    return user.toAuthAccount();
  }
}

class AuthServiceException implements Exception {
  const AuthServiceException({required this.code, this.message});

  final String code;
  final String? message;

  @override
  String toString() => 'AuthServiceException($code, $message)';
}

extension on User {
  AuthAccount toAuthAccount({String? displayName}) {
    return AuthAccount(
      uid: uid,
      email: email ?? '',
      displayName: displayName?.isNotEmpty == true
          ? displayName
          : this.displayName,
    );
  }
}
