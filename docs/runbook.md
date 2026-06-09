# Runbook exploitation

Ce runbook décrit les incidents probables et les actions de diagnostic.

## Génération IA indisponible

### Symptômes

- Message utilisateur : génération momentanément indisponible.
- Callable retourne `unavailable` ou `internal`.

### Vérifications

1. Vérifier les logs Cloud Functions.
2. Vérifier que `OPENAI_API_KEY` est configurée.
3. Vérifier le statut OpenAI.
4. Vérifier que la réponse OpenAI respecte le schéma attendu.
5. Vérifier que le timeout de 120 secondes n'est pas dépassé.

### Actions

- Redéployer les Functions si le secret ou la config runtime a changé.
- Ajouter un test backend si un nouveau format de réponse OpenAI est observé.
- Garder le message utilisateur générique et non technique.

## Quota IA atteint

### Symptômes

- Message utilisateur : quota IA temporairement atteint.
- Callable retourne `resource-exhausted`.

### Vérifications

1. Lire le document `aiQuotas/{uid}_{YYYY-MM}` via Firebase Console.
2. Vérifier les champs `mealPlanGenerationsUsed` ou `mealReplacementsUsed`.
3. Vérifier si l'utilisateur a fait plusieurs tentatives concurrentes.

### Actions

- Ne pas modifier le quota manuellement sauf support explicite.
- Si un quota est incorrect à cause d'un incident, ajuster le compteur dans Firestore Admin avec prudence.

## App Check refuse les appels

### Symptômes

- Les callables échouent avant logique métier.
- Fonctionne en debug mais pas en release.

### Vérifications

1. Confirmer que le provider App Check est configuré dans Firebase Console.
2. Vérifier la clé `APP_CHECK_RECAPTCHA_SITE_KEY` pour le web.
3. Vérifier Play Integrity sur Android.
4. Vérifier App Attest/DeviceCheck sur Apple.

### Actions

- Enregistrer les tokens debug uniquement pour l'environnement de développement.
- Ne pas désactiver `enforceAppCheck` en production sauf incident majeur temporaire.

## Erreurs Crashlytics élevées

### Vérifications

1. Identifier la version/build concernée.
2. Lire la stack trace Crashlytics.
3. Chercher le fichier/ligne Flutter correspondant.
4. Reproduire localement.
5. Ajouter un test de régression.

### Actions

- Corriger le root cause.
- Publier une version patch.
- Surveiller la baisse de l'événement.

## Plan expiré

### Symptômes

- L'utilisateur voit : plan IA expiré.
- Le plan local dépasse la fenêtre de 7 jours.

### Actions

- L'utilisateur doit régénérer un plan.
- Le flag `profileNeedsPlanRegeneration` est marqué localement.

## Firestore permission denied côté client

### Explication

C'est attendu. Les règles Firestore refusent tous les accès client. Les quotas passent par Admin SDK dans Functions.

### Action

Ne pas ouvrir les règles Firestore sauf ajout volontaire d'une fonctionnalité de synchronisation cloud avec règles dédiées.

## Checklist incident production

- Identifier : client, Functions, OpenAI, Firestore, App Check ou Auth.
- Vérifier Analytics pour volume et impact.
- Vérifier Crashlytics pour stack traces.
- Vérifier Cloud Functions logs.
- Reproduire localement si possible.
- Corriger avec test.
- Redéployer.
- Documenter l'incident si nécessaire.
