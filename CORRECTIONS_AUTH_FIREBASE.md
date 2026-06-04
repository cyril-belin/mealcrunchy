# Corrections — Intégration Firebase Auth

Review effectuée le 04/06/2026. Toutes les corrections sont classées par priorité.

---

## Priorité 1 — Comportement splash / redirect auth

### Problème

Le `redirect` dans `app_router.dart` renvoie immédiatement tout utilisateur non connecté vers `/auth`, y compris depuis le splash. L'écran de bienvenue n'est donc jamais visible pour un nouveau visiteur.

```dart
// app_router.dart
if (!authViewModel.isAuthenticated) {
  return isAuthRoute ? null : AppRoutes.auth;
}
```

### Correction

Ajouter `AppRoutes.splash` à la liste des routes accessibles sans authentification, et laisser l'utilisateur naviguer manuellement vers `/auth` depuis le bouton du splash.

```dart
redirect: (context, state) {
  final location = state.uri.path;
  final isAuthRoute = location == AppRoutes.auth;
  final isSplashRoute = location == AppRoutes.splash;

  if (authViewModel.isLoading) return null;

  // Routes accessibles sans authentification
  if (isSplashRoute || isAuthRoute) {
    // Si déjà connecté, sortir du splash/auth vers l'app
    if (authViewModel.isAuthenticated) return AppRoutes.onboardingGoals;
    return null;
  }

  // Route protégée sans authentification → login
  if (!authViewModel.isAuthenticated) return AppRoutes.auth;

  return null;
},
```

---

## Priorité 2 — Ne pas masquer les erreurs Firebase critiques

### Problème

Dans `main.dart`, l'erreur d'initialisation Firebase est silencieusement ignorée avec un simple `debugPrint`. L'app continue à tourner même si Firebase n'est pas configuré.

```dart
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(...);
  } on FirebaseException catch (error) {
    debugPrint('Firebase initialization skipped: ${error.code}'); // ← silencieux
  }
}
```

Et dans `FirebaseAuthService.authStateChanges()` :

```dart
} on AuthServiceException {
  return Stream<AuthAccount?>.value(null); // ← Firebase cassé = utilisateur non connecté
}
```

### Correction

Dans `main.dart`, rethrow l'erreur ou afficher une `runApp` avec un écran d'erreur explicite :

```dart
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (error) {
    // Ne pas silencier en production — logger ou afficher une erreur
    debugPrint('[FATAL] Firebase initialization failed: ${error.code} ${error.message ?? ''}');
    rethrow; // ou : runApp(const FirebaseErrorApp());
  }
}
```

Dans `FirebaseAuthService`, propager l'erreur au lieu de la masquer :

```dart
@override
Stream<AuthAccount?> authStateChanges() {
  return _auth.authStateChanges().map((user) => user?.toAuthAccount());
  // Supprimer le try/catch qui transforme une erreur de config en null
}
```

---

## Priorité 3 — Améliorer le formulaire d'authentification

### Problème

Le formulaire actuel a plusieurs lacunes UX/fonctionnelles :

- Validation uniquement sur `isEmpty`, pas de vérification de format email
- Pas de `Form` + `FormField` pour la gestion des erreurs champ par champ
- Icône de visibilité du mot de passe non interactive
- Pas d'`autofillHints.newPassword` à l'inscription (utilise `.password`)
- Pas de `TextInputType.name` sur le champ nom

### Corrections à apporter

**a) Utiliser `Form` et `TextFormField`**

Remplacer les `TextField` simples par `TextFormField` dans un `Form` avec une `GlobalKey<FormState>` :

```dart
final _formKey = GlobalKey<FormState>();

// Dans le build :
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Champ requis.';
          if (!value.contains('@')) return 'Adresse e-mail invalide.';
          return null;
        },
        // ...
      ),
      // ...
    ],
  ),
)
```

**b) Rendre l'icône de visibilité interactive**

```dart
// Ajouter dans le state :
var _passwordVisible = false;

// Dans le TextField / TextFormField mot de passe :
obscureText: !_passwordVisible,
decoration: InputDecoration(
  suffixIcon: IconButton(
    icon: Icon(
      _passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
    ),
    onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
  ),
),
```

**c) Corriger les `autofillHints` à l'inscription**

```dart
// À l'inscription, utiliser newPassword
autofillHints: _isSignUp
    ? const [AutofillHints.newPassword]
    : const [AutofillHints.password],
```

**d) Corriger le `keyboardType` du champ nom**

```dart
keyboardType: TextInputType.name,
textCapitalization: TextCapitalization.words,
```

---

## Priorité 4 — Changer le bundle identifier

### Problème

L'`applicationId` Android et le bundle iOS sont encore les valeurs par défaut Flutter :

```kotlin
// android/app/build.gradle.kts
applicationId = "com.example.mealcrunchy"
```

```dart
// lib/firebase_options.dart
iosBundleId: 'com.example.mealcrunchy'
```

### Correction

1. Choisir un identifiant définitif, ex. `com.cyrilbelin.mealcrunchy`
2. Mettre à jour `android/app/build.gradle.kts`
3. Mettre à jour le bundle iOS dans Xcode (`Runner > TARGETS > Runner > Bundle Identifier`)
4. Relancer `flutterfire configure` pour régénérer `firebase_options.dart` avec le bon bundle id
5. Mettre à jour la configuration Firebase Console si nécessaire

---

## Priorité 5 — Corriger les accents dans les messages

### Problème

Plusieurs messages d'erreur/UI manquent d'accents français, ce qui donne une impression de texte brut non finalisé.

### Fichiers concernés

**`lib/data/repositories/auth_repository.dart`** :

| Avant | Après |
|-------|-------|
| `Aucun compte ne correspond a cette adresse e-mail.` | `Aucun compte ne correspond à cette adresse e-mail.` |
| `Cette adresse e-mail est deja utilisee.` | `Cette adresse e-mail est déjà utilisée.` |
| `Verifiez votre connexion internet.` | `Vérifiez votre connexion internet.` |
| `Compte introuvable apres authentification.` | `Compte introuvable après authentification.` |
| `Firebase n'est pas encore configure` | `Firebase n'est pas encore configuré` |

**`lib/ui/features/auth/views/login_sign_up_screen.dart`** :

| Avant | Après |
|-------|-------|
| `Creer un compte` | `Créer un compte` |
| `Vous avez deja un compte ?` | `Vous avez déjà un compte ?` |
| `Votre guide nutritionnel personnalise par l'IA` | `Votre guide nutritionnel personnalisé par l'IA` |

---

## Priorité 6 — Corriger `_handleAuthState` pour les changements de profil

### Problème

La méthode ne compare que le `uid`. Si le `displayName` change pour le même utilisateur, l'UI ne sera pas notifiée.

```dart
// auth_view_model.dart
void _handleAuthState(AuthAccount? account) {
  final currentAccount = switch (authState) {
    ViewData(data: final data) => data,
    _ => null,
  };
  if (currentAccount?.uid == account?.uid) {
    return; // ← bloque la notif si uid identique mais displayName changé
  }
  authState = ViewData(account);
  notifyListeners();
}
```

### Correction

Implémenter `==` et `hashCode` sur `AuthAccount`, puis comparer l'objet complet :

```dart
// domain/models/auth_account.dart
class AuthAccount {
  const AuthAccount({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;

  @override
  bool operator ==(Object other) =>
      other is AuthAccount &&
      other.uid == uid &&
      other.email == email &&
      other.displayName == displayName;

  @override
  int get hashCode => Object.hash(uid, email, displayName);
}
```

Puis dans le ViewModel :

```dart
void _handleAuthState(AuthAccount? account) {
  final currentAccount = switch (authState) {
    ViewData(data: final data) => data,
    _ => null,
  };
  if (currentAccount == account) return; // compare maintenant tous les champs
  authState = ViewData(account);
  notifyListeners();
}
```

---

## Résumé

| # | Correction | Impact | Effort |
|---|-----------|--------|--------|
| 1 | Comportement splash/redirect auth | Produit | Faible |
| 2 | Ne pas masquer les erreurs Firebase | Robustesse | Faible |
| 3 | Améliorer le formulaire auth | UX | Moyen |
| 4 | Changer le bundle identifier | Production | Moyen |
| 5 | Corriger les accents | Qualité | Faible |
| 6 | `_handleAuthState` comparaison complète | Robustesse | Faible |
