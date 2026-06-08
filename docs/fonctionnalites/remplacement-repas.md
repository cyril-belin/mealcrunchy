# Remplacement repas

## Objectif

Permettre a l'utilisateur de remplacer un repas precis par une alternative IA compatible avec son profil et le reste du plan.

## Perimetre inclus

- Action "remplacer" depuis le detail ou le dashboard.
- Appel au proxy `replaceMeal`.
- Conservation du reste du plan.
- Validation de l'alternative recue.
- Sauvegarde locale du plan mis a jour.
- Gestion loading, succes et erreur.

## Hors perimetre

- Edition complete du planning.
- Deplacement de repas entre jours.
- Modification manuelle des ingredients.
- Regeneration complete du plan.

## Fichiers probablement concernes

- `lib/ui/features/meal_plan/views/meal_details_screen.dart`
- `lib/ui/features/meal_plan/views/daily_meal_plan_screen.dart`
- `lib/ui/features/meal_plan/view_models/meal_plan_view_model.dart`
- services IA et stockage local
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que le detail repas est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter le ViewModel et les modeles de plan.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas modifier les autres repas du plan pendant un remplacement unitaire.

## Tests a ecrire avant le code

- Test repository : remplacement d'un repas conserve les autres repas.
- Test repository : alternative invalide refusee.
- Test ViewModel : etat loading pendant remplacement.
- Test ViewModel : plan local mis a jour apres succes.
- Test widget : erreur visible si le remplacement echoue.

## Etapes d'implementation

1. Definir le contrat de remplacement cote app.
2. Ajouter les tests de remplacement unitaire.
3. Implementer l'appel au proxy.
4. Ajouter l'action dans le ViewModel.
5. Ajouter le controle UI sans surcharger l'ecran.
6. Sauvegarder le plan mis a jour localement.
7. Retester dashboard, detail et suivi quotidien.

## Commandes de validation

```bash
flutter test
flutter analyze
```

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-07 | `flutter analyze` | 2 lints dans le faux repository de test : parametre `store` inutilise et initialisation de champ perfectible | Helper de test trop generique pour les nouveaux tests ViewModel | Constructeur simplifie et initialisation directe du completer | `flutter analyze` relance avec succes |
| 2026-06-07 | MCP Flutter `widget_inspector get_widget_tree` | DTD non connecte | Aucune application Flutter active connectee au Dart Tooling Daemon | Absence documentee ; validation realisee par tests widget, MCP Dart, `flutter test` et `flutter analyze` | `flutter test`, `flutter analyze`, MCP Dart OK |
| 2026-06-07 | Clic simulateur sur `Remplacer` | L'alternative IA pouvait etre refusee comme invalide | Le proxy demande de conserver le type du repas, mais pas l'id ; l'IA peut donc renvoyer un nouvel id alors que l'app doit garder l'id local pour le routage et le suivi | Le repository conserve l'id du repas original avant sauvegarde et continue de refuser un type different | `flutter test test/repositories_test.dart`, `flutter test`, `flutter analyze` |
| 2026-06-07 | Clic simulateur sur `Remplacer` depuis le detail | `Repas introuvable dans le plan actif.` | L'ecran detail pouvait afficher un repas deja charge dans le ViewModel pendant que le repository relisait un plan local dont l'id ne correspondait plus | Le ViewModel transmet le repas affiche au repository ; si l'id est absent du plan local, le repository remplace le repas du jour de meme type en conservant l'id local | `flutter test test/repositories_test.dart test/ui/features/meal_plan/view_models/meal_plan_view_model_test.dart test/ui/features/meal_plan/views/meal_details_screen_test.dart test/ui/features/meal_plan/views/daily_meal_plan_screen_test.dart`, `flutter analyze`, `flutter test` |

## Checklist de fin

- [x] Un repas peut etre remplace sans changer le reste du plan.
- [x] Le plan modifie est sauvegarde.
- [x] Les erreurs de remplacement sont affichees.
- [x] Les tests repository et ViewModel passent.
- [x] Les tests widget passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer la liste de courses tant que le remplacement repas n'est pas valide.
