# Authentification compte simple

## Objectif

Ajouter une authentification simple pour identifier l'utilisateur, proteger l'usage IA et preparer la synchronisation future, sans remplacer le stockage local du MVP.

## Perimetre inclus

- Connexion et creation de compte avec Firebase Auth.
- Gestion des etats : non connecte, chargement, connecte, erreur.
- Redirection vers l'onboarding ou le plan selon l'etat utilisateur.
- Messages d'erreur lisibles en francais.
- Tests de logique d'authentification et tests widget de l'ecran de connexion.

## Hors perimetre

- Paiement ou abonnement.
- Synchronisation complete Firestore.
- Recuperation avancee de compte.
- Connexion sociale Google, Apple ou Facebook, sauf decision explicite dans une nouvelle spec.

## Fichiers probablement concernes

- `pubspec.yaml`
- `lib/ui/features/auth/views/login_sign_up_screen.dart`
- `lib/ui/core/routing/app_router.dart`
- `lib/ui/core/routing/app_routes.dart`
- `lib/ui/app.dart`
- nouveaux fichiers possibles sous `lib/data/services/`, `lib/data/repositories/` et `lib/ui/features/auth/`
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie a cette fonctionnalite.
- Lire `docs/fonctionnalites/00-roadmap-globale.md`.
- Passer le statut de cette fonctionnalite a `En cours` dans la roadmap globale avant de modifier le code.
- Lire l'ecran auth existant et le routeur avant toute modification.
- Utiliser les skills Flutter et Dart adaptes, notamment pour les tests widget, les tests unitaires et l'analyse statique.
- Utiliser le MCP Dart pour inspecter les symboles et packages.
- Utiliser le MCP Flutter si disponible ; sinon noter son absence dans la section "Erreurs rencontrees et resolution".
- Ne pas casser les ecrans existants : splash, onboarding, plan repas, detail repas et profil.

## Tests a ecrire avant le code

- Test unitaire du repository ou service d'authentification avec succes de connexion.
- Test unitaire du cas erreur Firebase transforme en message francais.
- Test ViewModel : changement d'etat `loading` puis `data` apres connexion.
- Test widget : formulaire affiche email, mot de passe, bouton de connexion et bouton de creation de compte.
- Test widget : message d'erreur visible si la connexion echoue.

## Etapes d'implementation

1. Verifier les dependances Firebase deja presentes ou absentes.
2. Ajouter uniquement les packages necessaires.
3. Creer une couche service/repository pour isoler Firebase Auth de l'UI.
4. Ajouter un ViewModel d'authentification.
5. Brancher l'ecran existant sur le ViewModel.
6. Adapter le routage selon l'etat connecte/non connecte.
7. Executer les tests apres chaque etape importante.
8. Corriger les regressions sans modifier les fonctionnalites non concernees.

## Commandes de validation

```bash
flutter test
flutter analyze
```

Si un changement de dependance est fait :

```bash
flutter pub get
```

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-04 | `flutterfire configure` | `zsh:1: command not found: flutterfire` | FlutterFire CLI absent de l'environnement local | `dart pub global activate flutterfire_cli` | `flutterfire --version` retourne `1.4.0` |
| 2026-06-04 | `dart format lib test analysis_options.yaml` | Dart a tente de parser le YAML et a quitte avec le code 65 | Mauvais perimetre de formatage | Relance avec `dart format lib test` uniquement | `dart format lib test` passe |
| 2026-06-04 | `flutter pub get` en parallele avec `flutter test` et `flutter analyze` | Crash Flutter `PathExistsException` sur `ios/Flutter/ephemeral/Packages/.packages/firebase_core-4.10.0` | Collision SwiftPM due a deux commandes Flutter concurrentes | Relancer `flutter pub get` seul | `flutter pub get` passe |
| 2026-06-04 | `flutter analyze` | Lint `prefer_initializing_formals` dans un fake de test | Constructeur de test ajoute pour verifier les changements `AuthAccount` | Utilisation d'un initializing formal compatible avec le callsite Dart | `flutter analyze` passe |
| 2026-06-04 | MCP Flutter / DTD | `The dart tooling daemon is not connected` | Aucune app Flutter lancee et connectee au DTD pendant ces corrections | Validation effectuee via MCP Dart `analyze_files`, `flutter test` et `flutter analyze` | MCP Dart `analyze_files` retourne `No errors` |
| 2026-06-04 | `flutter pub get` sandbox | `Operation not permitted` sur le cache Flutter local | Le cache Flutter est hors workspace sandbox | Relance autorisee hors sandbox | `flutter pub get` passe |

## Checklist de fin

- [x] Les tests unitaires d'authentification passent.
- [x] Les tests widget de l'ecran auth passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] Les ecrans existants critiques ont ete retestes via tests widget.
- [x] Les erreurs et resolutions sont documentees.
- [x] La roadmap globale est mise a jour avec le statut `Terminee`.

## Derniere mise a jour

- Date : 2026-06-04
- Statut : `Terminee`
- Code : corrections Firebase Auth de `CORRECTIONS_AUTH_FIREBASE.md` appliquees.
- Firebase : projet `mealcrunchy-20260604` cree, apps Android/iOS/macOS/Web configurees via FlutterFire.
- Provider : Email/Password active via `firebase deploy --only auth`.
- Routage : `/` et `/auth` restent publics pour les utilisateurs non connectes ; les routes privees redirigent vers `/auth` ; les utilisateurs connectes partent vers `/onboarding/goals`.
- Formulaire : `Form` + `TextFormField`, validations champ par champ, visibilite mot de passe, hints d'autofill inscription et textes francais accentues.
- Firebase critique : les erreurs d'initialisation et de configuration ne sont plus converties silencieusement en utilisateur non connecte.
- Identifiant publication : bundle/application ID passe a `com.cyrilbelin.mealcrunchy` via `RESTE_A_FAIRE.md`, avec regeneration FlutterFire.
- Validation : `dart format lib test`, MCP Dart `pub deps`, MCP Dart `analyze_files`, `flutter pub get`, `flutter test` et `flutter analyze` passent.

## Mise a jour obligatoire du fichier global

Avant de fermer la fenetre de travail :

- mettre le statut a `Terminee`, `Bloquee` ou `Tests en cours` ;
- renseigner la section "Derniere mise a jour" ;
- reporter les erreurs importantes dans `00-roadmap-globale.md` ;
- ne pas demarrer l'onboarding tant que cette fonctionnalite n'est pas terminee.
