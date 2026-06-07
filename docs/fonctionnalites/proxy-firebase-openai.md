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

Commandes executees pendant l'implementation :

```bash
npm install --prefix functions
npm test --prefix functions
flutter test test/data/services/ai_proxy_service_test.dart
flutter test
flutter analyze
MCP Dart analyze_files
```

Commande Firebase a executer avant un deploiement reel, sans jamais commiter la valeur du secret :

```bash
firebase functions:secrets:set OPENAI_API_KEY
```

## Erreurs rencontrees et resolution

Le proxy utilise Firebase Functions v2 callable en region `europe-west1`, un secret `OPENAI_API_KEY`, et l'API OpenAI Responses avec Structured Outputs.

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-06 | `npm install` dans `functions/` | Installation bloquee sans sortie dans la sandbox | Acces reseau restreint pendant le telechargement npm | Processus interrompu puis `npm install` relance avec permission reseau | `npm test --prefix functions` OK |
| 2026-06-06 | `npm install` dans `functions/` | `EBADENGINE` local | Le projet Functions cible Node 22, la machine locale utilise Node 24.15.0 | Aucune correction necessaire pour le runtime Firebase `nodejs22`; avertissement documente | `npm test --prefix functions` OK |
| 2026-06-06 | `npm audit` implicite | 9 vulnerabilites moderees dans l'arbre npm | Dependances transitives Firebase/npm | Documente pour suivi ; pas de `npm audit fix --force` afin d'eviter une mise a jour cassante hors scope | Build et tests Functions OK |
| 2026-06-06 | `npm test --prefix functions` apres tests rouges | `Cannot find module './proxy'` | Test ecrit avant implementation TDD | Ajout des handlers purs `buildGenerateMealPlanHandler` et `buildReplaceMealHandler` | `npm test --prefix functions` OK |
| 2026-06-06 | `flutter test test/data/services/ai_proxy_service_test.dart` apres tests rouges | `ai_proxy_service.dart` introuvable | Test Flutter ecrit avant implementation TDD | Ajout de `cloud_functions` et du service `AiProxyService` injectable | Test service OK |
| 2026-06-06 | MCP Flutter `widget_inspector get_widget_tree` | DTD non connecte | Aucune application Flutter active connectee au Dart Tooling Daemon | Absence documentee ; validation realisee par tests unitaires/service et analyse statique | `flutter test`, `flutter analyze`, MCP Dart OK |

## Checklist de fin

- [x] La cle OpenAI n'est jamais exposee cote Flutter.
- [x] Les functions valident les entrees.
- [x] Les functions valident les sorties OpenAI.
- [x] Les erreurs sont documentees.
- [x] Les tests functions ou tests de service passent.
- [x] `flutter test` passe pour la partie Flutter.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour.

## Validation finale

- `npm test --prefix functions` : OK, 6 tests Functions.
- `flutter test test/data/services/ai_proxy_service_test.dart` : OK, 5 tests service.
- `flutter test` : OK, 78 tests.
- `flutter analyze` : OK, aucune erreur.
- MCP Dart `analyze_files` : OK, aucune erreur.
- MCP Flutter / widget inspector : DTD non connecte, absence documentee ci-dessus.

## Mise a jour obligatoire du fichier global

Reporter le statut, les commandes Firebase/OpenAI importantes et les erreurs dans `00-roadmap-globale.md`. Ne pas commencer la generation de plan tant que le proxy n'est pas valide.
