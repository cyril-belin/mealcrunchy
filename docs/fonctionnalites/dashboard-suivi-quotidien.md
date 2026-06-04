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

Aucune erreur documentee a ce stade.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|

## Checklist de fin

- [ ] L'utilisateur peut cocher et decocher un repas.
- [ ] La progression calories/macros est correcte.
- [ ] Le suivi est persiste localement.
- [ ] Les tests ViewModel passent.
- [ ] Les tests widget passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer le detail repas tant que le dashboard n'est pas valide.
