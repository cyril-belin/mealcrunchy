# Backend IA et quotas

## Vue d'ensemble

Le backend IA est implémenté avec Firebase Cloud Functions v2 en TypeScript.

Il expose deux callables :

| Function | Rôle |
|---|---|
| `generateMealPlan` | Génère un plan repas personnalisé sur 7 jours |
| `replaceMeal` | Remplace un repas existant par une alternative compatible |

Les fonctions sont déployées en région `europe-west1`.

## Fichiers principaux

```text
functions/src/
├── index.ts      # Exports Firebase Functions, options runtime et App Check
├── openai.ts     # Appels OpenAI Responses API + schémas JSON stricts
├── proxy.ts      # Validation callable, mapping erreurs, orchestration quotas/OpenAI
├── quotas.ts     # Store Firestore transactionnel pour quotas mensuels
└── *.test.ts     # Tests backend Node.js
```

## Flux `generateMealPlan`

1. Le client appelle `AiProxyService.generateMealPlan`.
2. Firebase callable vérifie l'authentification et App Check.
3. `proxy.ts` valide le payload : profil, locale, nombre de jours.
4. Le backend réserve un quota `mealPlanGeneration` dans Firestore.
5. `openai.ts` appelle l'API OpenAI Responses avec un schéma JSON strict.
6. `proxy.ts` revalide la réponse IA.
7. La fonction retourne `{ plan, usage }`.
8. Le client parse, stocke le plan localement, régénère la liste de courses et expose le quota restant.
9. Si OpenAI échoue après réservation, le quota est libéré.

## Flux `replaceMeal`

1. Le client transmet le profil, le repas courant et le contexte du plan.
2. Le backend réserve un quota `mealReplacement`.
3. OpenAI génère une alternative structurée.
4. Le backend vérifie que le type du repas est valide.
5. Le client remplace le repas localement en conservant l'id du repas original.
6. La liste de courses est régénérée.

## Structured Outputs

OpenAI est appelé avec `text.format.type = json_schema` et `strict = true`.

Le backend définit :

- un schéma `meal_plan_response` ;
- un schéma `replace_meal_response` ;
- un schéma commun `mealSchema`.

La réponse IA est ensuite revalidée côté serveur pour ne jamais faire confiance uniquement au modèle.

## Quotas IA

Les quotas sont stockés dans Firestore via Admin SDK.

| Quota | Limite |
|---|---:|
| Génération plan repas | 1 / mois / utilisateur |
| Remplacement repas | 10 / mois / utilisateur |

Le document Firestore suit la clé :

```text
aiQuotas/{uid}_{YYYY-MM}
```

Champs principaux :

- `uid` ;
- `periodKey` ;
- `mealPlanGenerationsUsed` ;
- `mealReplacementsUsed` ;
- `updatedAt`.

## Garantie anti-concurrence

Les quotas sont modifiés dans une transaction Firestore :

1. lecture du compteur courant ;
2. vérification `used < limit` ;
3. incrément atomique ;
4. retour de l'usage `{periodKey, limit, used, remaining}`.

En cas d'échec après réservation, `releaseUsage` décrémente dans une transaction distincte.

## Erreurs backend

| Cas | Code callable |
|---|---|
| Non connecté | `unauthenticated` |
| Payload invalide | `invalid-argument` |
| Quota dépassé | `resource-exhausted` |
| Réponse OpenAI invalide | `internal` |
| Service indisponible | `unavailable` |

Le client mappe ces codes vers des messages français non techniques.
