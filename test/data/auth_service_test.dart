import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';

void main() {
  group('FirebaseAuthService', () {
    test('propagates Firebase configuration errors from authStateChanges', () {
      final service = FirebaseAuthService(
        firebaseAuthProvider: () => throw FirebaseException(
          plugin: 'firebase_core',
          code: 'no-app',
          message: 'Firebase has not been initialized.',
        ),
      );

      expect(service.authStateChanges, throwsA(isA<AuthServiceException>()));
    });
  });
}
