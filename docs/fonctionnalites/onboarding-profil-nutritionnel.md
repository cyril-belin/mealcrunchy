# Onboarding profil nutritionnel

## Objectif

Transformer l'onboarding existant en collecte fiable du profil nutritionnel utilise pour personnaliser les plans repas.

## Perimetre inclus

- Objectif principal : sante, perte de poids ou fitness.
- Preferences alimentaires, allergies, activite, mensurations et rythme de repas.
- Validation des champs obligatoires.
- Conservation de l'etat pendant le parcours.
- Preparation d'un modele `UserProfile` ou equivalent.
- Tests des selections, validations et transitions d'etapes.

## Hors perimetre

- Generation IA du plan.
- Sauvegarde persistante definitive, traitee dans `stockage-local-donnees.md`.
- Refonte visuelle complete des ecrans.
- Conseils medicaux ou regimes therapeutiques.

## Fichiers probablement concernes

- `lib/ui/features/onboarding/view_models/onboarding_view_model.dart`
- `lib/ui/features/onboarding/views/`
- `lib/domain/models/onboarding_option.dart`
- nouveaux modeles possibles sous `lib/domain/models/`
- tests sous `test/`

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier dans la roadmap globale que l'authentification est `Terminee`.
- Passer cette fonctionnalite a `En cours` avant de modifier le code.
- Lire tous les ecrans onboarding existants et le ViewModel actuel.
- Utiliser les skills Flutter et Dart adaptes.
- Utiliser le MCP Dart pour inspecter les types existants.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne pas casser le parcours actuel entre splash, auth, onboarding et generation.

## Tests a ecrire avant le code

- Test ViewModel : selection d'un objectif unique.
- Test ViewModel : allergies multi-selection.
- Test ViewModel : validation refuse un profil incomplet.
- Test ViewModel : creation d'un profil valide avec objectif, activite et mensurations.
- Test widget : navigation entre au moins deux etapes d'onboarding.

## Etapes d'implementation

1. Identifier les donnees deja presentes dans `OnboardingViewModel`.
2. Definir le modele de profil minimal pour le MVP.
3. Ajouter les tests de validation du profil.
4. Adapter le ViewModel pour exposer un profil final valide.
5. Brancher les ecrans existants sans changer inutilement le design.
6. Gerer les erreurs de champs manquants de facon visible et simple.
7. Retester le parcours complet d'onboarding.

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

- [ ] Le profil nutritionnel peut etre construit depuis l'onboarding.
- [ ] Les validations empechent un profil incomplet.
- [ ] Les tests ViewModel passent.
- [ ] Les tests widget passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut final, la date, les tests executes et les erreurs importantes dans `00-roadmap-globale.md`. Ne pas commencer le stockage local tant que cette fonctionnalite n'est pas validee.
