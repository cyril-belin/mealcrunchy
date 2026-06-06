# Detail repas

## Objectif

Afficher un detail repas fiable, coherent avec le dashboard et utilisable pour cuisiner le repas choisi.

## Perimetre inclus

- Nom, type, duree, calories et macros.
- Ingredients.
- Instructions.
- Cohérence des valeurs entre dashboard et detail.
- Etat repas introuvable.
- Tests widget du detail.

## Hors perimetre

- Remplacement du repas.
- Modification des portions.
- Images generees ou assets photo.
- Notes utilisateur.

## Fichiers probablement concernes

- `lib/ui/features/meal_plan/views/meal_details_screen.dart`
- `lib/ui/features/meal_plan/view_models/meal_plan_view_model.dart`
- `lib/domain/models/meal.dart`
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que le dashboard suivi quotidien est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter le modele repas et le ViewModel.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas introduire de valeurs magiques differentes entre liste et detail.

## Tests a ecrire avant le code

- Test widget : affiche nom, calories, macros, ingredients et instructions.
- Test widget : affiche un etat repas introuvable pour un ID inconnu.
- Test ViewModel : `mealById` retourne le bon repas.
- Test de coherence : valeurs affichees identiques aux valeurs du modele.

## Etapes d'implementation

1. Lire l'ecran detail existant.
2. Ajouter les tests de coherence.
3. Supprimer ou eviter toute transformation UI non justifiee des donnees.
4. Adapter l'affichage pour les repas issus du plan IA.
5. Gerer clairement le cas repas absent.
6. Retester navigation depuis le dashboard.

## Commandes de validation

```bash
flutter test
flutter analyze
```

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-06 | MCP Flutter / widget inspector | DTD non connecte : `The dart tooling daemon is not connected` | Aucune application Flutter active connectee au DTD dans ce contexte. | Inspection live documentee comme indisponible ; validation realisee par tests widget, MCP Dart, `flutter test` et `flutter analyze`. | `flutter test` et `flutter analyze` valides. |

## Checklist de fin

- [x] Le detail affiche les donnees exactes du repas.
- [x] Le cas repas introuvable est gere.
- [x] La navigation depuis le dashboard fonctionne.
- [x] Les tests widget passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Notes d'implementation

- Le detail repas est en lecture seule : les actions prototype de favori et de repas mange localement ont ete retirees pour eviter un etat de session incoherent avec le dashboard.
- Le dashboard et le detail utilisent les memes valeurs du modele `Meal` pour calories, macros et type lisible.
- La navigation dashboard vers detail reste basee sur `AppRoutes.mealDetailsFor(meal.id)`.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer le remplacement repas tant que le detail repas n'est pas valide.
