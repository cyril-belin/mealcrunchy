# Stockage local des donnees

## Objectif

Sauvegarder localement le profil utilisateur, le plan actif, le suivi quotidien et la liste de courses afin que l'app reste utilisable sans synchronisation cloud complete.

## Perimetre inclus

- Choix d'une solution de stockage locale compatible Flutter.
- Persistance du profil nutritionnel.
- Persistance du plan repas actif.
- Persistance des repas coches comme consommes.
- Persistance de la liste de courses et de ses cases cochees.
- Tests de lecture, ecriture, mise a jour et donnees corrompues.

## Hors perimetre

- Synchronisation multi-appareils.
- Firestore comme source principale.
- Chiffrement avance des donnees.
- Historique nutritionnel long terme detaille.

## Fichiers probablement concernes

- `pubspec.yaml`
- `lib/data/services/`
- `lib/data/repositories/`
- `lib/domain/models/`
- ViewModels qui consomment profil, plan et suivi
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que l'onboarding est `Terminee` dans la roadmap globale.
- Passer cette fonctionnalite a `En cours`.
- Utiliser le MCP Dart pour rechercher et inspecter les packages de stockage envisages.
- Utiliser les skills Dart et Flutter adaptes, notamment tests unitaires et analyse statique.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas casser les repositories statiques existants tant que la migration n'est pas testee.

## Tests a ecrire avant le code

- Test service : sauvegarde puis recharge d'un profil.
- Test service : sauvegarde puis recharge d'un plan.
- Test service : mise a jour d'un repas consomme.
- Test service : gestion d'une valeur absente.
- Test service : gestion d'un JSON invalide ou incomplet.

## Etapes d'implementation

1. Choisir la solution locale la plus simple pour le MVP.
2. Ajouter les tests du service de stockage.
3. Implementer une interface de stockage isolant le package choisi.
4. Ajouter la serialisation necessaire aux modeles concernes.
5. Brancher progressivement les repositories.
6. Retester les ecrans existants avec donnees sauvegardees puis rechargees.
7. Documenter tout changement de schema local.

## Commandes de validation

```bash
flutter pub get
flutter test
flutter analyze
```

## Erreurs rencontrees et resolution

Le stockage local utilise `shared_preferences` deja present dans le projet, avec la nouvelle API `SharedPreferencesAsync` recommandee pour les nouveaux usages.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-06 | MCP Flutter `widget_inspector get_widget_tree` | DTD non connecte | Aucune application Flutter active connectee au Dart Tooling Daemon | Absence documentee ; validation realisee par tests widget, `flutter test`, `flutter analyze` et MCP Dart `analyze_files` | OK |
| 2026-06-06 | `flutter test test/ui/features/onboarding/views/onboarding_flow_test.dart` | `SharedPreferencesAsyncPlatform instance must be set` | Les tests widgets configuraient l'ancienne API `SharedPreferences`, pas l'API async | `MealCrunchyApp` rend `LocalDataStore` injectable et les tests utilisent un faux store local | `flutter test test/ui/features/onboarding/views/onboarding_flow_test.dart` OK |
| 2026-06-06 | `flutter analyze` | `prefer_initializing_formals` | Le store local du ViewModel etait initialise via un parametre intermediaire | Champ renomme en propriete immuable initialisee par `this.localDataStore` | `flutter analyze` OK |

## Checklist de fin

- [x] Les donnees principales sont sauvegardees localement.
- [x] Les donnees sont rechargees apres redemarrage de l'app.
- [x] Les tests couvrent lecture, ecriture et erreur.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Validation finale

- `flutter pub get` : OK.
- `flutter test` : OK.
- `flutter analyze` : OK.
- MCP Dart `analyze_files` : OK, aucune erreur.
- MCP Flutter / widget inspector : DTD non connecte, absence documentee ci-dessus.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer le proxy Firebase OpenAI tant que le stockage local n'est pas valide.
