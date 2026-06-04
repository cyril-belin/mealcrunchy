# Generation plan IA 7 jours

## Objectif

Generer un plan repas personnalise sur 7 jours a partir du profil nutritionnel utilisateur, via le proxy Firebase OpenAI.

## Perimetre inclus

- Appel au proxy de generation.
- Mode chargement, succes et erreur.
- Plan de 7 jours avec petit-dejeuner, dejeuner, diner et collation si applicable.
- Calories, macros, ingredients, instructions et duree pour chaque repas.
- Validation du plan avant sauvegarde locale.
- Sauvegarde du plan genere comme plan actif.

## Hors perimetre

- Remplacement individuel d'un repas.
- Liste de courses detaillee.
- Paiement ou quotas, sauf consommation minimale exposee par le proxy.
- Recommandation medicale.

## Fichiers probablement concernes

- `lib/domain/models/`
- `lib/data/repositories/meal_plan_repository.dart`
- nouveaux services IA sous `lib/data/services/`
- `lib/ui/features/onboarding/views/generating_plan_screen.dart`
- `lib/ui/features/meal_plan/view_models/meal_plan_view_model.dart`
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que le proxy Firebase OpenAI est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter les modeles et signatures.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas remplacer les donnees statiques tant que le nouveau flux n'est pas teste.
- Garder une strategie de fallback claire si le proxy echoue.

## Tests a ecrire avant le code

- Test repository : generation reussie retourne un plan de 7 jours.
- Test repository : JSON invalide leve une erreur controlee.
- Test ViewModel : expose loading pendant la generation.
- Test ViewModel : sauvegarde le plan apres succes.
- Test widget : l'ecran de generation affiche chargement puis navigation ou erreur.

## Etapes d'implementation

1. Definir ou completer les modeles du plan 7 jours.
2. Ajouter les tests de parsing et validation.
3. Implementer l'appel au proxy via service dedie.
4. Brancher le repository de plan.
5. Adapter l'ecran `GeneratingPlanScreen`.
6. Sauvegarder le plan actif localement.
7. Verifier l'affichage dans le dashboard existant.
8. Documenter les erreurs IA et les donnees rejetees.

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

- [ ] Un plan 7 jours valide est genere.
- [ ] Le plan est sauvegarde localement.
- [ ] Les erreurs IA sont affichees proprement.
- [ ] Les tests de modele, repository et ViewModel passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer le dashboard quotidien tant que la generation 7 jours n'est pas validee.
