# Dashboard suivi quotidien

## Objectif

Faire du dashboard quotidien le coeur d'usage : afficher les repas du jour, permettre de les cocher comme consommes et montrer une progression simple calories/macros.

## Perimetre inclus

- Affichage du jour courant dans le plan 7 jours.
- Liste des repas du jour.
- Action pour marquer un repas comme consomme ou non consomme.
- Progression calories et macros basee sur les repas coches.
- Persistance locale du suivi quotidien.
- Etats loading, data et error.

## Hors perimetre

- Journal alimentaire libre.
- Saisie manuelle de portions.
- Historique long terme avance.
- Graphiques complexes.

## Fichiers probablement concernes

- `lib/ui/features/meal_plan/views/daily_meal_plan_screen.dart`
- `lib/ui/features/meal_plan/view_models/meal_plan_view_model.dart`
- `lib/domain/models/`
- repositories/services de stockage local
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que la generation plan IA 7 jours est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes, notamment widget tests et tests ViewModel.
- Utiliser le MCP Dart pour inspecter `MealPlanViewModel` et les modeles.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas casser la navigation vers le detail repas.

## Tests a ecrire avant le code

- Test ViewModel : repas coche augmente les calories consommees.
- Test ViewModel : repas decoche retire les calories.
- Test ViewModel : suivi recharge depuis stockage local.
- Test widget : bouton ou checkbox de repas visible et interactif.
- Test widget : progression change apres action utilisateur.

## Etapes d'implementation

1. Identifier le modele de suivi quotidien minimal.
2. Ajouter les tests de calcul calories/macros.
3. Ajouter les actions de coche dans le ViewModel.
4. Persister les changements localement.
5. Adapter l'UI du dashboard sans casser le design.
6. Retester navigation dashboard vers detail.
7. Documenter les regressions trouvees.

## Commandes de validation

```bash
flutter test
flutter analyze
```

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-06 | Tests dashboard rouges | Compilation en echec : `DailyMealTrackingStore`, `setMealConsumed`, `isMealConsumed` et injection `now` absents | Le dashboard etait encore statique : aucun modele de suivi quotidien ni API ViewModel pour cocher les repas. | Ajout du store de suivi quotidien, du calcul dans `MealPlanViewModel`, et de la checkbox par repas. | `flutter test test/ui/features/meal_plan/view_models/meal_plan_view_model_test.dart test/ui/features/meal_plan/views/daily_meal_plan_screen_test.dart` valide. |
| 2026-06-06 | `flutter test` complet | Ancien test ViewModel passe en `ViewError` et deux tests widget expirent sur `pumpAndSettle` | Les tests existants n'isolaient pas encore `SharedPreferences` apres l'ajout de la persistance locale du suivi quotidien. | Tests existants ajustes avec `MemoryDailyMealTrackingStore` ou `SharedPreferences.setMockInitialValues`. | `flutter test` complet valide. |
| 2026-06-06 | Test widget dashboard | Date du dashboard encore codee en dur : `Aujourd'hui, 24 oct.` | Le header n'utilisait pas la date courante. | Ajout de `MealPlanViewModel.currentDayLabel` base sur la date courante injectable. | Test widget `Aujourd'hui, 6 juin` valide. |

## Checklist de fin

- [x] L'utilisateur peut cocher et decocher un repas.
- [x] La progression calories/macros est correcte.
- [x] Le suivi est persiste localement.
- [x] Les tests ViewModel passent.
- [x] Les tests widget passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Notes d'implementation

- Le dashboard utilise les repas du plan du jour actuellement disponibles dans `StaticDesignContentService`, car la generation IA 7 jours reste hors de cette tranche.
- Les repas coches sont persistes localement par jour avec `shared_preferences`.
- Le resume calories/macros n'utilise plus les calories consommees statiques : il est calcule depuis les repas coches.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer le detail repas tant que le dashboard n'est pas valide.
