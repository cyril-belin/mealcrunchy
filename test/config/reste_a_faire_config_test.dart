import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('project release configuration', () {
    test('uses the production bundle identifier in project files', () {
      final files = [
        'android/app/build.gradle.kts',
        'android/app/google-services.json',
        'android/app/src/main/kotlin/fr/cyrilbelin/mealcrunchy/MainActivity.kt',
        'ios/Runner/GoogleService-Info.plist',
        'ios/Runner.xcodeproj/project.pbxproj',
        'linux/CMakeLists.txt',
        'macos/Runner/GoogleService-Info.plist',
        'macos/Runner.xcodeproj/project.pbxproj',
        'macos/Runner/Configs/AppInfo.xcconfig',
        'lib/firebase_options.dart',
      ];

      for (final path in files) {
        final content = File(path).readAsStringSync();
        expect(
          content,
          contains('com.cyrilbelin.mealcrunchy'),
          reason: '$path should use the production bundle identifier.',
        );
        expect(
          content,
          isNot(contains('com.example.mealcrunchy')),
          reason: '$path should not keep the default Flutter identifier.',
        );
      }
    });

    test('does not sign Android release builds with debug keys', () {
      final content = File('android/app/build.gradle.kts').readAsStringSync();

      expect(content, contains('android/key.properties'));
      expect(content, contains('storeFile'));
      expect(content, isNot(contains('signingConfigs.getByName("debug")')));
    });

    test('keeps Android release signing secrets out of git', () {
      final content = File('.gitignore').readAsStringSync();

      expect(content, contains('/android/key.properties'));
    });

    test('denies direct client access to Firestore by default', () {
      final firebaseConfig = File('firebase.json').readAsStringSync();

      expect(firebaseConfig, contains('"firestore"'));
      expect(firebaseConfig, contains('"rules": "firestore.rules"'));

      final rules = File('firestore.rules').readAsStringSync();

      expect(rules, contains('service cloud.firestore'));
      expect(rules, contains('match /databases/{database}/documents'));
      expect(rules, contains('allow read, write: if false;'));
    });

    test('uses a MealCrunchy project description', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();

      expect(
        pubspec,
        contains(
          'description: "MealCrunchy — application mobile de nutrition personnalisée par IA."',
        ),
      );

      for (final path in ['web/index.html', 'web/manifest.json']) {
        final content = File(path).readAsStringSync();
        expect(content, contains('MealCrunchy'));
        expect(content, isNot(contains('A new Flutter project.')));
      }
    });
  });
}
