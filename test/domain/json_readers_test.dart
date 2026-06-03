import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/domain/models/json_readers.dart';

void main() {
  group('readJsonField', () {
    test('returns the value when the type matches', () {
      expect(readJsonField<int>({'a': 1}, 'a'), 1);
    });

    test('throws FormatException when the key is missing', () {
      expect(() => readJsonField<int>({}, 'a'), throwsFormatException);
    });

    test('throws FormatException when the type is wrong', () {
      expect(() => readJsonField<int>({'a': 'x'}, 'a'), throwsFormatException);
    });
  });

  group('readStringList', () {
    test('returns a list of strings', () {
      expect(
        readStringList({
          'a': ['x', 'y'],
        }, 'a'),
        ['x', 'y'],
      );
    });

    test('throws FormatException when the value is not a list', () {
      expect(() => readStringList({'a': 1}, 'a'), throwsFormatException);
    });

    test('throws FormatException when a list item is not a string', () {
      expect(
        () => readStringList({
          'a': ['x', 1],
        }, 'a'),
        throwsFormatException,
      );
    });
  });
}
