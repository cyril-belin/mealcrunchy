# Liste de courses

## Objectif

Generer une liste de courses simple a partir du plan 7 jours et permettre a l'utilisateur de cocher les articles localement.

## Perimetre inclus

- Extraction des ingredients du plan actif.
- Regroupement simple par categorie si les donnees le permettent.
- Cases a cocher persistantes localement.
- Regeneration de la liste quand le plan change.
- Tests de generation et persistance.

## Hors perimetre

- Quantites nutritionnelles precises.
- Export PDF ou partage.
- Scan de produits.
- Substitutions d'ingredients.

## Fichiers probablement concernes

- nouveaux modeles sous `lib/domain/models/`
- services/repositories de liste de courses
- nouvel ecran possible sous `lib/ui/features/`
- routage si nouvel ecran dedie
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que le remplacement repas est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter les modeles de plan.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas casser le plan actif ni le suivi quotidien.

## Tests a ecrire avant le code

- Test service : extrait les ingredients de plusieurs repas.
- Test service : fusionne les doublons simples.
- Test service : conserve les cases cochees apres regeneration compatible.
- Test ViewModel : coche et decoche un item.
- Test widget : liste affiche les items et cases a cocher.

## Etapes d'implementation

1. Definir le modele `ShoppingListItem` ou equivalent.
2. Ajouter les tests de generation depuis plan.
3. Implementer le service de generation.
4. Ajouter la persistance locale des cases cochees.
5. Creer ou brancher l'ecran liste de courses.
6. Ajouter la navigation necessaire.
7. Retester remplacement repas puis regeneration de liste.

## Commandes de validation

```bash
flutter test
flutter analyze
```

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-07 | `flutter test` cible widget liste de courses | Assertion Flutter `ListTile background color or ink splashes may be invisible` | `CheckboxListTile` etait place dans `SoftCard`, dont le `DecoratedBox` masque les effets Material | Remplacement par une ligne custom avec `InkWell`, `Checkbox`, texte et quantite | `flutter test test/ui/features/shopping_list/views/shopping_list_screen_test.dart` puis `flutter test` |
| 2026-06-07 | `flutter analyze` | Warning `unused_import` dans `shopping_list_repository.dart` | Import `MealPlan` devenu inutile apres simplification du repository | Import supprime | `flutter analyze` relance avec succes |
| 2026-06-07 | MCP Flutter `widget_inspector get_widget_tree` | DTD non connecte | Aucune application Flutter active connectee au Dart Tooling Daemon | Absence documentee ; validation realisee par tests widget, `flutter test`, `flutter analyze` et MCP Dart `analyze_files` | `flutter test`, `flutter analyze`, MCP Dart OK |

## Checklist de fin

- [x] La liste est generee depuis le plan actif.
- [x] Les items peuvent etre coches et decoches.
- [x] L'etat des cases est persiste.
- [x] Les tests service et ViewModel passent.
- [x] Les tests widget passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer profil et preferences tant que la liste de courses n'est pas validee.
