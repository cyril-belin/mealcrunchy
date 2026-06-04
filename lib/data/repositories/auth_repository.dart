import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';

class AuthRepository {
  const AuthRepository({required this.service});

  final AuthService service;

  AuthAccount? get currentAccount => service.currentAccount;

  Stream<AuthAccount?> authStateChanges() => service.authStateChanges();

  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await service.signIn(email: email, password: password);
    } on AuthServiceException catch (error) {
      throw AuthRepositoryException(_messageForCode(error.code));
    }
  }

  Future<AuthAccount> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      return await service.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    } on AuthServiceException catch (error) {
      throw AuthRepositoryException(_messageForCode(error.code));
    }
  }

  Future<void> signOut() async {
    try {
      await service.signOut();
    } on AuthServiceException catch (error) {
      throw AuthRepositoryException(_messageForCode(error.code));
    }
  }

  String _messageForCode(String code) {
    return switch (code) {
      'invalid-email' => 'Adresse e-mail invalide.',
      'user-not-found' => 'Aucun compte ne correspond à cette adresse e-mail.',
      'wrong-password' => 'Mot de passe incorrect.',
      'invalid-credential' => 'Identifiants invalides.',
      'email-already-in-use' => 'Cette adresse e-mail est déjà utilisée.',
      'weak-password' =>
        'Mot de passe trop faible. Utilisez au moins 6 caractères.',
      'network-request-failed' =>
        'Connexion impossible. Vérifiez votre connexion internet.',
      'missing-user' => 'Compte introuvable après authentification.',
      'no-app' || 'core/no-app' =>
        'Firebase n\'est pas encore configuré pour cette application.',
      _ => 'Authentification impossible pour le moment.',
    };
  }
}

class AuthRepositoryException implements Exception {
  const AuthRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
