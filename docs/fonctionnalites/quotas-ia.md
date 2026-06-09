# Quotas IA

## Objectif

Limiter l'usage gratuit des generations IA par compte afin de controler les couts OpenAI et eviter les abus.

## Limites MVP retenues

- Periode : mensuelle UTC, cle `YYYY-MM`.
- Generation de plan : 1 generation par compte et par mois.
- Remplacement de repas : 10 remplacements par compte et par mois.
- Stockage serveur : collection Firestore Admin `aiQuotas`, document `${uid}_${periodKey}`.
- Champs serveur : `uid`, `periodKey`, `mealPlanGenerationsUsed`, `mealReplacementsUsed`, `updatedAt`.
- Securite client : `firestore.rules` refuse toute lecture/ecriture directe ; seul l'Admin SDK des Functions manipule les quotas.
- Concurrence : le quota est reserve transactionnellement avant OpenAI, puis libere si OpenAI echoue ou si la reponse IA est invalide.

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

```bash
cd functions && npm test
flutter test test/data/services/ai_proxy_service_test.dart test/ui/features/onboarding/views/generating_plan_screen_test.dart test/ui/features/meal_plan/view_models/meal_plan_view_model_test.dart test/ui/features/meal_plan/views/meal_details_screen_test.dart
flutter test test/config/reste_a_faire_config_test.dart
flutter test
flutter analyze
```

Validation MCP Dart : `analyze_files` sur les services et ViewModels IA/quota.

Validation MCP Flutter : DTD connecte, mais `widget_inspector get_widget_tree` a retourne `Bad state: No element` sur l'app connectee ; validation UI realisee par tests widget.

## Erreurs rencontrees et resolution

| Date | Commande ou action | Erreur | Cause | Resolution | Retest |
|---|---|---|---|---|---|
| 2026-06-08 | `git switch -c codex/quotas-ia` | `Operation not permitted` sur `.git/refs/heads/...lock` | Sandbox en lecture seule sur `.git` | Commande relancee avec autorisation d'ecriture Git | Branche `codex/quotas-ia` creee |
| 2026-06-08 | MCP Flutter `widget_inspector get_widget_tree` | `Bad state: No element` | App connectee au DTD sans element inspectable disponible | Absence d'inspection widget live documentee ; validation UI couverte par tests widget | Tests widget quota generation/remplacement |
| 2026-06-08 | Revue quotas IA | Risque de cout OpenAI perdu sous concurrence au dernier quota | Le flux initial verifiait avant OpenAI puis incrementait apres validation | Reservation transactionnelle avant OpenAI et liberation si OpenAI/payload invalide echoue | `cd functions && npm test` |

## Checklist de fin

- [x] Le quota est verifie cote serveur.
- [x] Le quota est reserve avant OpenAI et libere si la generation valide echoue.
- [x] L'utilisateur voit un message clair si le quota est atteint.
- [x] Les regles Firestore refusent les acces directs client.
- [x] Les tests proxy passent.
- [x] Les tests Flutter passent.
- [x] `flutter test` passe.
- [x] `flutter analyze` passe.
- [x] La roadmap globale est mise a jour avec `Terminee`.

## Mise a jour obligatoire du fichier global

Reporter le statut final, les tests, les limites choisies et les erreurs dans `00-roadmap-globale.md`. Cette fonctionnalite clot la sequence MVP definie dans la roadmap actuelle.
