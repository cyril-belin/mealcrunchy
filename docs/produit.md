# Vue produit

## Mission

MealCrunchy accompagne l'utilisateur dans la planification nutritionnelle quotidienne grâce à une application Flutter simple, personnalisée et augmentée par IA.

L'application couvre le parcours complet :

1. création de compte ;
2. onboarding nutritionnel ;
3. génération d'un plan repas IA sur 7 jours ;
4. suivi quotidien des repas consommés ;
5. consultation du détail des repas ;
6. remplacement d'un repas par IA ;
7. génération et suivi de la liste de courses ;
8. modification du profil et des préférences ;
9. affichage des quotas IA restants.

## Utilisateur cible

- Personne souhaitant organiser ses repas sans construire manuellement un menu.
- Utilisateur avec objectifs nutritionnels : perte de poids, maintien, prise de masse ou équilibre.
- Utilisateur avec allergies, aversions, régime spécifique ou contraintes d'activité.

## Fonctionnalités livrées

| Domaine | Fonctionnalité | Statut |
|---|---|:---:|
| Authentification | Email/password via Firebase Auth | Livré |
| Onboarding | Objectif, régime, allergies, activité, mensurations | Livré |
| IA | Plan repas personnalisé sur 7 jours | Livré |
| Dashboard | Progression calories/macros, repas consommés | Livré |
| Détail repas | Calories, macros, ingrédients, instructions | Livré |
| Remplacement IA | Alternative compatible avec le profil | Livré |
| Liste de courses | Agrégation des ingrédients du plan actif | Livré |
| Profil | Consultation et modification des préférences | Livré |
| Quotas | 1 génération plan + 10 remplacements/mois | Livré |
| Sécurité | App Check, Auth, secrets, Firestore deny-all | Livré |
| Observabilité | Analytics + Crashlytics | Livré |
| i18n | Localisation Flutter, dates `fr_FR` | Livré |
| Thème | Clair/sombre selon système | Livré |

## Parcours utilisateur principal

1. L'utilisateur ouvre l'application.
2. Il crée un compte ou se connecte.
3. Il renseigne son profil nutritionnel.
4. L'application appelle `generateMealPlan` via Firebase Functions.
5. Le backend valide la requête, réserve un quota, appelle OpenAI, valide la réponse et retourne le plan.
6. L'app stocke le plan localement et affiche le dashboard du jour.
7. L'utilisateur coche les repas consommés, consulte les détails, remplace un repas ou ouvre sa liste de courses.
8. Si le profil change, l'application marque le plan comme nécessitant une régénération.

## Limites produit connues

- Les quotas sont mensuels et fixes côté backend.
- Les données utilisateur sont principalement stockées localement ; il n'y a pas encore de synchronisation cloud du profil ou du plan.
- Le choix manuel du thème n'est pas encore persistant ; le thème suit le système.
- L'accessibilité peut encore être renforcée via semantics, focus order et audit contraste.
