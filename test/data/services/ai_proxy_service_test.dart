import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

void main() {
  group('AiProxyService', () {
    test('generateMealPlan returns the callable plan payload', () async {
      final client = _FakeAiCallableClient(
        responses: {
          'generateMealPlan': {
            'plan': {
              'days': const <Object?>[],
              'summary': {'targetCalories': 2000},
            },
            'usage': null,
          },
        },
      );
      final service = AiProxyService(client: client);

      final result = await service.generateMealPlan(profile: _profile);

      expect(result['plan'], isA<Map<String, Object?>>());
      expect(client.calls.single.name, 'generateMealPlan');
      expect(client.calls.single.data['profile'], _profile.toJson());
      expect(client.calls.single.data['days'], 7);
      expect(client.calls.single.data['locale'], 'fr-FR');
    });

    test('replaceMeal returns the callable meal payload', () async {
      final client = _FakeAiCallableClient(
        responses: {
          'replaceMeal': {'meal': _meal.toJson()},
        },
      );
      final service = AiProxyService(client: client);

      final result = await service.replaceMeal(
        profile: _profile,
        currentMeal: _meal,
        planContext: {
          'meals': [_meal.toJson()],
        },
      );

      expect(result['meal'], isA<Map<String, Object?>>());
      expect(client.calls.single.name, 'replaceMeal');
      expect(client.calls.single.data['currentMeal'], _meal.toJson());
    });

    test('maps network errors to an unavailable service error', () async {
      final service = AiProxyService(
        client: _FakeAiCallableClient(
          exception: const AiCallableException(code: 'unavailable'),
        ),
      );

      await expectLater(
        service.generateMealPlan(profile: _profile),
        throwsA(
          isA<AiProxyException>()
              .having((error) => error.code, 'code', 'unavailable')
              .having(
                (error) => error.message,
                'message',
                'Generation IA momentanement indisponible.',
              ),
        ),
      );
    });

    test('maps quota errors to a clear service error', () async {
      final service = AiProxyService(
        client: _FakeAiCallableClient(
          exception: const AiCallableException(code: 'resource-exhausted'),
        ),
      );

      await expectLater(
        service.generateMealPlan(profile: _profile),
        throwsA(
          isA<AiProxyException>()
              .having((error) => error.code, 'code', 'resource-exhausted')
              .having(
                (error) => error.message,
                'message',
                'Quota IA temporairement atteint.',
              ),
        ),
      );
    });

    test('rejects invalid callable response formats', () async {
      final service = AiProxyService(
        client: _FakeAiCallableClient(
          responses: {
            'generateMealPlan': {'usage': null},
          },
        ),
      );

      await expectLater(
        service.generateMealPlan(profile: _profile),
        throwsA(
          isA<AiProxyException>().having(
            (error) => error.code,
            'code',
            'invalid-response',
          ),
        ),
      );
    });
  });
}

const _profile = UserProfile(
  goal: 'Perdre du poids',
  dietStyle: 'Mediterraneen',
  allergies: ['Cacahuetes'],
  customAversions: ['Olives'],
  activityLevel: 'Moderement actif',
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

const _meal = Meal(
  id: 'breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Omelette aux herbes',
  calories: 420,
  protein: 31,
  carbs: 18,
  fat: 24,
  imagePrompt: 'omelette healthy breakfast',
  duration: '15 min',
  ingredients: ['2 oeufs', 'Herbes fraiches'],
  instructions: ['Battre les oeufs.', 'Cuire a feu doux.'],
);

class _FakeAiCallableClient implements AiCallableClient {
  _FakeAiCallableClient({this.responses = const {}, this.exception});

  final Map<String, Object?> responses;
  final AiCallableException? exception;
  final List<_Call> calls = [];

  @override
  Future<Object?> call(String name, Map<String, Object?> data) async {
    calls.add(_Call(name, data));
    final exception = this.exception;
    if (exception != null) {
      throw exception;
    }
    return responses[name];
  }
}

class _Call {
  const _Call(this.name, this.data);

  final String name;
  final Map<String, Object?> data;
}
