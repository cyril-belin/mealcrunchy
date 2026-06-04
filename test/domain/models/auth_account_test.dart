import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';

void main() {
  group('AuthAccount', () {
    test('uses uid, email and displayName for equality', () {
      const account = AuthAccount(
        uid: 'user-1',
        email: 'alex@example.com',
        displayName: 'Alex Rivers',
      );

      expect(
        account,
        const AuthAccount(
          uid: 'user-1',
          email: 'alex@example.com',
          displayName: 'Alex Rivers',
        ),
      );
      expect(
        account,
        isNot(
          const AuthAccount(
            uid: 'user-1',
            email: 'alex@example.com',
            displayName: 'Alex Martin',
          ),
        ),
      );
    });
  });
}
