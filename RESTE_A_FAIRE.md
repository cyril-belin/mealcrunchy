# Reste à faire — MealCrunchy

État au 04/06/2026. Les corrections listées ci-dessous ont été appliquées côté projet.
Le seul élément qui reste volontairement externe au dépôt est la création du keystore Android et du fichier secret `android/key.properties`.

---

## 1. Changer le bundle identifier (avant toute publication) — Terminé

### Où

- `android/app/build.gradle.kts` — `applicationId` et `namespace` passés à `com.cyrilbelin.mealcrunchy`.
- `ios/Runner.xcodeproj` — bundle identifier passé à `com.cyrilbelin.mealcrunchy`.
- `macos/Runner/Configs/AppInfo.xcconfig` — bundle identifier passé à `com.cyrilbelin.mealcrunchy`.
- `linux/CMakeLists.txt` — application ID Linux passé à `com.cyrilbelin.mealcrunchy`.
- `lib/firebase_options.dart` — `iosBundleId` iOS/macOS passé à `com.cyrilbelin.mealcrunchy`.
- Console Firebase — nouvelles apps Android/iOS enregistrées via FlutterFire pour `com.cyrilbelin.mealcrunchy`.
- Configs natives — `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist` et `macos/Runner/GoogleService-Info.plist` régénérés.

### Pourquoi

L'identifiant actuel `com.example.mealcrunchy` est le placeholder par défaut Flutter.
Il ne peut pas être publié sur le Play Store ou l'App Store avec cet identifiant.

### Comment

**1. Android — `android/app/build.gradle.kts`**

```kotlin
// Avant
namespace = "com.example.mealcrunchy"
applicationId = "com.example.mealcrunchy"

// Après
namespace = "com.cyrilbelin.mealcrunchy"
applicationId = "com.cyrilbelin.mealcrunchy"
```

**2. iOS — Xcode**

Ouvrir `ios/Runner.xcodeproj` dans Xcode :
`Runner > TARGETS > Runner > General > Bundle Identifier`

Remplacer `com.example.mealcrunchy` par `com.cyrilbelin.mealcrunchy`.

Faire de même pour `macos/Runner.xcodeproj`.

**3. Régénérer `firebase_options.dart`**

Une fois les bundle IDs mis à jour dans la console Firebase :

```bash
flutterfire configure
```

---

## 2. Configurer le signing de release Android — Configuration projet terminée

### Où

`android/app/build.gradle.kts`

### Pourquoi

Actuellement, le build release signe avec les clés de debug :

```kotlin
// android/app/build.gradle.kts
release {
  signingConfig = signingConfigs.getByName("debug") // ← pas pour la production
}
```

Un APK/AAB signé avec les clés debug ne peut pas être publié.

### Ce qui est fait

- `android/app/build.gradle.kts` lit `android/key.properties` quand il existe.
- Le build release n'utilise plus `signingConfigs.getByName("debug")`.
- `android/key.properties` est ajouté au `.gitignore`.

### À faire hors dépôt avant publication

1. Générer un keystore :

```bash
keytool -genkey -v -keystore ~/mealcrunchy-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias mealcrunchy
```

2. Créer `android/key.properties` (ne pas committer ce fichier) :

```properties
storePassword=ton_mot_de_passe
keyPassword=ton_mot_de_passe
keyAlias=mealcrunchy
storeFile=/Users/cyril/mealcrunchy-release.jks
```

3. Ne pas committer `android/key.properties` ni le keystore.

---

## 3. Mettre à jour la description du projet — Terminé

### Où

`pubspec.yaml`, `web/index.html` et `web/manifest.json`.

### Pourquoi

La description est encore la valeur par défaut Flutter :

```yaml
description: "A new Flutter project."
```

### Correction

```yaml
description: "MealCrunchy — application mobile de nutrition personnalisée par IA."
```

---

## Résumé

| # | Tâche | Statut | Notes |
|---|-------|--------|-------|
| 1 | Changer bundle identifier Android + iOS + Firebase | Terminé | FlutterFire a enregistré les nouvelles apps Android/iOS et régénéré les configs locales. |
| 2 | Configurer signing release Android | Projet prêt | Keystore et `android/key.properties` restent à créer localement avec tes secrets. |
| 3 | Mettre à jour la description projet | Terminé | `pubspec.yaml` et métadonnées web mises à jour. |
