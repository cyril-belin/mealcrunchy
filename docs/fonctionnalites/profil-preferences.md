# Profil et preferences

## Objectif

Permettre a l'utilisateur de consulter et modifier ses choix d'onboarding depuis l'ecran profil/preferences.

## Perimetre inclus

- Affichage du profil nutritionnel sauvegarde.
- Acces a la modification des preferences principales.
- Sauvegarde locale des modifications.
- Indication claire si un changement necessite de regenerer le plan.
- Tests du ViewModel et de l'ecran profil.

## Hors perimetre

- Synchronisation cloud complete.
- Suppression de compte.
- Export des donnees personnelles.
- Parametres avances de confidentialite.

## Fichiers probablement concernes

- `lib/ui/features/profile/views/profile_preferences_screen.dart`
- `lib/ui/features/profile/view_models/profile_view_model.dart`
- repositories de preferences
- stockage local
- routage onboarding si edition via parcours existant
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que la liste de courses est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter `ProfileViewModel` et les repositories.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas perdre le plan actif sans confirmation utilisateur.

## Tests a ecrire avant le code

- Test ViewModel : charge les preferences sauvegardees.
- Test ViewModel : met a jour une preference.
- Test ViewModel : signale qu'un plan doit etre regenere apres changement majeur.
- Test widget : affiche les preferences actuelles.
- Test widget : action modifier visible et fonctionnelle.

## Etapes d'implementation

1. Lire l'ecran profil existant et son ViewModel.
2. Ajouter les tests de chargement et mise a jour.
3. Brancher les donnees sauvegardees plutot que les donnees statiques.
4. Ajouter le flux de modification minimal.
5. Signaler clairement les changements qui impactent le plan.
6. Retester onboarding, plan actif et profil.

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

- [ ] Le profil affiche les vraies preferences sauvegardees.
- [ ] Les preferences modifiables sont sauvegardees.
- [ ] Les changements impactant le plan sont signales.
- [ ] Les tests ViewModel passent.
- [ ] Les tests widget passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les tests et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer quotas IA tant que profil et preferences n'est pas valide.
