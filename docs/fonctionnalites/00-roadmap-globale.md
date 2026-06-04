# MealCrunchy - Roadmap globale des fonctionnalites

## Regle principale

Une seule fonctionnalite peut etre active a la fois.

Il est interdit de commencer une nouvelle fonctionnalite tant que la fonctionnalite en cours n'est pas :

- implementee ;
- testee ;
- retestee apres correction ;
- documentee dans son fichier dedie ;
- reportee dans cette roadmap globale.

Chaque nouvelle fonctionnalite doit etre traitee dans une nouvelle fenetre ou un nouveau contexte Codex afin de garder un contexte propre et controlable.

## Statuts autorises

- `A faire` : pas encore commencee.
- `En cours` : implementation active dans une fenetre dediee.
- `Tests en cours` : code ecrit, validation en cours.
- `Terminee` : implementation, tests, retests et documentation termines.
- `Bloquee` : impossible d'avancer sans decision, dependance ou correction externe.

## Ordre obligatoire d'implementation

| Ordre | Fonctionnalite | Statut | Fichier de controle |
|---:|---|---|---|
| 1 | Authentification compte simple | Terminee | [authentification-compte-simple.md](authentification-compte-simple.md) |
| 2 | Onboarding profil nutritionnel | A faire | [onboarding-profil-nutritionnel.md](onboarding-profil-nutritionnel.md) |
| 3 | Stockage local des donnees | A faire | [stockage-local-donnees.md](stockage-local-donnees.md) |
| 4 | Proxy Firebase OpenAI | A faire | [proxy-firebase-openai.md](proxy-firebase-openai.md) |
| 5 | Generation plan IA 7 jours | A faire | [generation-plan-ia-7-jours.md](generation-plan-ia-7-jours.md) |
| 6 | Dashboard suivi quotidien | A faire | [dashboard-suivi-quotidien.md](dashboard-suivi-quotidien.md) |
| 7 | Detail repas | A faire | [detail-repas.md](detail-repas.md) |
| 8 | Remplacement repas | A faire | [remplacement-repas.md](remplacement-repas.md) |
| 9 | Liste de courses | A faire | [liste-courses.md](liste-courses.md) |
| 10 | Profil et preferences | A faire | [profil-preferences.md](profil-preferences.md) |
| 11 | Quotas IA | A faire | [quotas-ia.md](quotas-ia.md) |

## Regles communes obligatoires

Pour chaque fonctionnalite :

1. Ouvrir une nouvelle fenetre ou un nouveau contexte Codex.
2. Lire le fichier Markdown dedie avant toute action.
3. Lire le code existant concerne avant toute modification.
4. Ne pas casser le code existant qui fonctionne.
5. Utiliser les skills Flutter et Dart adaptes a la tache.
6. Utiliser le MCP Dart pour inspecter les symboles, packages et API quand c'est utile.
7. Utiliser le MCP Flutter si disponible dans la nouvelle fenetre.
8. Si un skill ou MCP demande n'est pas disponible, le documenter dans le fichier de la fonctionnalite.
9. Ecrire ou mettre a jour les tests avant ou avec le code.
10. Lancer les tests apres chaque changement important.
11. Retester les fonctionnalites deja impactees.
12. Documenter chaque erreur, sa cause et sa resolution.
13. Mettre a jour cette roadmap globale avant de fermer la fenetre de travail.

## Derniere mise a jour

- Date : 2026-06-04
- Changement : corrections Firebase Auth appliquees et validees apres review `CORRECTIONS_AUTH_FIREBASE.md`.
- Fonctionnalite active : aucune.
- Prochaine fonctionnalite autorisee : Onboarding profil nutritionnel.

## Erreurs importantes rencontrees

| Date | Fonctionnalite | Erreur | Resolution |
|---|---|---|---|
| 2026-06-04 | Authentification compte simple | `flutterfire configure` indisponible : `command not found` | FlutterFire CLI installe via `dart pub global activate flutterfire_cli`, puis configuration Firebase relancee. |
| 2026-06-04 | Authentification compte simple | `flutter pub get` lance en parallele avec d'autres commandes Flutter a cause un crash SwiftPM `PathExistsException` | Relance de `flutter pub get` seul : commande validee. |
| 2026-06-04 | Authentification compte simple | MCP Flutter / DTD non connecte pendant les corrections Firebase Auth | Validation finale realisee avec MCP Dart `analyze_files`, `flutter test` et `flutter analyze`. |

## Historique de validation

| Date | Fonctionnalite | Resultat | Notes |
|---|---|---|---|
| 2026-06-03 | Documentation de pilotage | Terminee | Creation initiale des fichiers de controle. |
| 2026-06-04 | Authentification compte simple | Terminee | Projet Firebase `mealcrunchy-20260604`, apps Android/iOS/macOS/Web, provider Email/Password, tests et analyse valides. |
| 2026-06-04 | Authentification compte simple | Terminee | Corrections Firebase Auth validees : routage splash/auth, erreurs Firebase non masquees, formulaire `Form`, accents, egalite `AuthAccount`, puis bundle ID passe a `com.cyrilbelin.mealcrunchy` via `RESTE_A_FAIRE.md`. |
