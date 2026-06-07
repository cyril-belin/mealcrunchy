import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required AuthRepository authRepository,
    required LocalDataStore localDataStore,
  }) : _authRepository = authRepository,
       // ignore: prefer_initializing_formals
       _localDataStore = localDataStore,
       authState = ViewData(authRepository.currentAccount) {
    _subscription = _authRepository.authStateChanges().listen(_handleAuthState);
    if (authRepository.currentAccount != null) {
      _checkActiveMealPlan();
    }
  }

  final AuthRepository _authRepository;
  final LocalDataStore _localDataStore;
  late final StreamSubscription<AuthAccount?> _subscription;

  ViewState<AuthAccount?> authState;
  bool? _hasActiveMealPlan;

  bool get isLoading =>
      authState is ViewLoading<AuthAccount?> ||
      (isAuthenticated && _hasActiveMealPlan == null);

  bool get isAuthenticated {
    return switch (authState) {
      ViewData(data: final account) => account != null,
      _ => false,
    };
  }

  bool get hasActiveMealPlan => _hasActiveMealPlan ?? false;

  String? get errorMessage {
    return switch (authState) {
      ViewError(message: final message) => message,
      _ => null,
    };
  }

  Future<void> signIn({required String email, required String password}) async {
    await _runAuthAction(
      () => _authRepository.signIn(email: email, password: password),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _runAuthAction(
      () => _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> signOut() async {
    authState = const ViewLoading();
    _hasActiveMealPlan = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      authState = const ViewData(null);
    } on AuthRepositoryException catch (error) {
      authState = ViewError(error.message);
    }

    notifyListeners();
  }

  Future<void> _checkActiveMealPlan() async {
    final plan = await _localDataStore.loadActiveMealPlan();
    _hasActiveMealPlan = plan != null;
    notifyListeners();
  }

  Future<void> _runAuthAction(Future<AuthAccount> Function() action) async {
    authState = const ViewLoading();
    notifyListeners();

    try {
      final account = await action();
      authState = ViewData(account);
      await _checkActiveMealPlan();
    } on AuthRepositoryException catch (error) {
      authState = ViewError(error.message);
    } catch (_) {
      authState = const ViewError(
        'Authentification impossible pour le moment.',
      );
    }

    notifyListeners();
  }

  void _handleAuthState(AuthAccount? account) {
    final currentAccount = switch (authState) {
      ViewData(data: final data) => data,
      _ => null,
    };
    if (currentAccount == account) {
      return;
    }
    authState = ViewData(account);
    if (account != null) {
      _hasActiveMealPlan = null;
      _checkActiveMealPlan();
    } else {
      _hasActiveMealPlan = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
