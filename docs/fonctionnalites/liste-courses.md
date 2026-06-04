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

Aucune erreur documentee a ce stade.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|

## Checklist de fin

- [ ] La liste est generee depuis le plan actif.
- [ ] Les items peuvent etre coches et decoches.
- [ ] L'etat des cases est persiste.
- [ ] Les tests service et ViewModel passent.
- [ ] Les tests widget passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer profil et preferences tant que la liste de courses n'est pas validee.
