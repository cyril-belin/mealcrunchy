# Quotas IA

## Objectif

Limiter l'usage gratuit des generations IA par compte afin de controler les couts OpenAI et eviter les abus.

## Perimetre inclus

- Quota de generation de plan.
- Quota de remplacement de repas.
- Verification du quota avant appel OpenAI.
- Message utilisateur quand le quota est atteint.
- Tests cote proxy et cote Flutter service/ViewModel.

## Hors perimetre

- Paiement ou abonnement.
- Gestion commerciale avancee.
- Dashboard admin.
- Remboursements ou credits payants.

## Fichiers probablement concernes

- Firebase Functions du proxy OpenAI
- stockage de quotas cote Firebase
- services Flutter qui appellent le proxy
- ViewModels de generation et remplacement
- tests functions et tests Flutter

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que profil et preferences est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Flutter et Dart adaptes pour la partie app.
- Utiliser le MCP Dart pour inspecter les services et packages.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Ne jamais faire confiance au quota cote Flutter uniquement : la verification principale doit etre cote serveur.
- Ne pas exposer de secret OpenAI.

## Tests a ecrire avant le code

- Test function : autorise l'appel quand quota disponible.
- Test function : refuse l'appel quand quota epuise.
- Test function : decremente le quota apres succes OpenAI valide.
- Test function : ne decremente pas le quota si OpenAI echoue avant generation valide.
- Test Flutter : affiche un message clair quand le quota est atteint.

## Etapes d'implementation

1. Definir les limites gratuites initiales.
2. Ajouter les tests cote function.
3. Implementer la verification serveur avant OpenAI.
4. Implementer le decrement uniquement apres succes valide.
5. Retourner une erreur quota structuree a Flutter.
6. Adapter l'UI pour afficher le quota atteint.
7. Retester generation plan et remplacement repas.

## Commandes de validation

Les commandes exactes des functions dependront de la configuration Firebase. Au minimum pour l'app :

```bash
flutter test
flutter analyze
```

Ajouter ici les commandes Firebase executees pendant l'implementation.

## Erreurs rencontrees et resolution

Aucune erreur documentee a ce stade.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|

## Checklist de fin

- [ ] Le quota est verifie cote serveur.
- [ ] Le quota est decremente seulement apres succes valide.
- [ ] L'utilisateur voit un message clair si le quota est atteint.
- [ ] Les tests proxy passent.
- [ ] Les tests Flutter passent.
- [ ] `flutter test` passe.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour avec `Terminee`.

## Mise a jour obligatoire du fichier global

Reporter le statut final, les tests, les limites choisies et les erreurs dans `00-roadmap-globale.md`. Cette fonctionnalite clot la sequence MVP definie dans la roadmap actuelle.
