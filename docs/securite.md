# Sécurité

## Principes

MealCrunchy applique une stratégie de sécurité en couches :

1. authentification utilisateur ;
2. App Check pour les callables coûteux ;
3. secrets côté serveur ;
4. Firestore inaccessible côté client ;
5. validation stricte des entrées et sorties IA ;
6. quotas mensuels anti-abus.

## Firebase Authentication

L'application utilise Firebase Auth avec email/password.

Le client ne peut générer ou remplacer un repas que si l'utilisateur est authentifié. Les callables lisent `request.auth.uid` et refusent toute requête sans uid.

## Firebase App Check

Les Cloud Functions IA ont `enforceAppCheck: true`.

Côté client, App Check est activé par plateforme :

| Plateforme | Provider production | Provider debug |
|---|---|---|
| Android | Play Integrity | Android debug provider |
| Apple | App Attest avec fallback DeviceCheck | Apple debug provider |
| Web | reCAPTCHA Enterprise | Web debug provider |

La clé reCAPTCHA Enterprise est injectée via :

```bash
--dart-define=APP_CHECK_RECAPTCHA_SITE_KEY=...
```

## Secrets

La clé OpenAI est stockée comme secret Firebase :

```text
OPENAI_API_KEY
```

Elle est lue côté Functions via `defineSecret` et n'est jamais exposée au client.

Le fichier local `functions/.secret.local` est réservé au développement et doit rester gitignored.

## Firestore rules

Les règles Firestore refusent toute lecture/écriture client :

```text
allow read, write: if false;
```

Les quotas sont manipulés uniquement via Admin SDK dans Cloud Functions.

## Validation des données

Le backend valide :

- payload callable ;
- profil utilisateur ;
- locale ;
- nombre de jours ;
- structure du plan IA ;
- types de repas ;
- valeurs numériques calories/macros ;
- listes d'ingrédients/instructions.

Le client valide aussi les données locales via les modèles Dart.

## Quotas anti-abus

Même avec un utilisateur authentifié, les appels IA sont limités :

- 1 génération de plan par mois ;
- 10 remplacements de repas par mois.

La réservation se fait avant l'appel OpenAI, ce qui protège contre les appels concurrents. La réservation est libérée si OpenAI échoue.

## Recommandations opérationnelles

- Activer App Check en mode enforcement dans Firebase Console pour les plateformes ciblées.
- Surveiller les événements Analytics d'échec IA.
- Surveiller les erreurs Crashlytics liées à App Check ou Firebase initialization.
- Ne jamais commiter de clé OpenAI ou fichier secret.
- Garder `firestore.rules` deny-all tant que les données client ne sont pas synchronisées via Firestore.
