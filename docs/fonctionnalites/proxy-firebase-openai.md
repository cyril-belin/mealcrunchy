# Proxy Firebase OpenAI

## Objectif

Creer un proxy serverless Firebase qui appelle OpenAI sans exposer la cle API dans l'application Flutter.

## Perimetre inclus

- Firebase Cloud Function pour generation de plan.
- Firebase Cloud Function pour remplacement d'un repas.
- Stockage securise de la cle OpenAI cote serveur.
- Validation de la requete entrante.
- Validation de la reponse OpenAI avant retour a Flutter.
- Gestion des erreurs reseau, quota et format invalide.

## Hors perimetre

- Interface utilisateur de generation.
- Logique de plan repas cote Flutter, traitee dans `generation-plan-ia-7-jours.md`.
- Paiement.
- Systeme complet d'administration.

## Fichiers probablement concernes

- fichiers Firebase Functions a creer si le projet Firebase n'existe pas encore
- configuration Firebase
- `pubspec.yaml` si l'app Flutter doit appeler les functions
- services/repositories Flutter d'acces au proxy
- tests des functions et tests Flutter de service

## Regles obligatoires avant implementation

- Ouvrir une nouvelle fenetre ou un nouveau contexte Codex dedie.
- Verifier que le stockage local est `Terminee`.
- Passer cette fonctionnalite a `En cours`.
- Utiliser les skills Dart et Flutter adaptes pour la partie app.
- Utiliser le MCP Dart pour inspecter les packages Flutter Firebase.
- Utiliser le MCP Flutter si disponible ; sinon documenter son absence.
- Pour OpenAI, consulter la documentation officielle actuelle avant de figer le format d'appel.
- Ne jamais mettre la cle OpenAI dans le code Flutter, dans Git ou dans un fichier Markdown de suivi.

## Tests a ecrire avant le code

- Test function : refuse une requete sans utilisateur authentifie.
- Test function : refuse un profil invalide.
- Test function : transforme une erreur OpenAI en erreur exploitable.
- Test function : refuse une reponse OpenAI qui ne respecte pas le schema.
- Test Flutter service : gere succes, erreur reseau et erreur quota.

## Etapes d'implementation

1. Verifier l'etat de configuration Firebase du projet.
2. Creer ou completer le dossier Functions si necessaire.
3. Configurer le secret OpenAI cote Firebase.
4. Definir les contrats JSON d'entree et de sortie.
5. Implementer `generateMealPlan`.
6. Implementer `replaceMeal`.
7. Ajouter le service Flutter qui appelle les functions.
8. Tester localement ou avec emulateur quand possible.
9. Documenter toutes les commandes Firebase utilisees.

## Commandes de validation

Les commandes exactes dependront de la configuration Firebase creee pendant l'implementation. Au minimum :

```bash
flutter test
flutter analyze
```

Pour les functions, ajouter ici les commandes executees dans la fenetre dediee.

## Erreurs rencontrees et resolution

Aucune erreur documentee a ce stade.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|

## Checklist de fin

- [ ] La cle OpenAI n'est jamais exposee cote Flutter.
- [ ] Les functions valident les entrees.
- [ ] Les functions valident les sorties OpenAI.
- [ ] Les erreurs sont documentees.
- [ ] Les tests functions ou tests de service passent.
- [ ] `flutter test` passe pour la partie Flutter.
- [ ] `flutter analyze` passe.
- [ ] La roadmap globale est mise a jour.

## Mise a jour obligatoire du fichier global

Reporter le statut, les commandes Firebase/OpenAI importantes et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer la generation de plan tant que le proxy n'est pas valide.
