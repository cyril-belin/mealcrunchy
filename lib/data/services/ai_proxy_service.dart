import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

abstract class AiCallableClient {
  Future<Object?> call(String name, Map<String, Object?> data);
}

class FirebaseAiCallableClient implements AiCallableClient {
  FirebaseAiCallableClient({FirebaseFunctions? functions})
    : _functions =
          functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

  final FirebaseFunctions _functions;

  @override
  Future<Object?> call(String name, Map<String, Object?> data) async {
    try {
      final callable = _functions.httpsCallable(name);
      final result = await callable.call<Object?>(data);
      return result.data;
    } on FirebaseFunctionsException catch (error) {
      throw AiCallableException(code: error.code, message: error.message);
    } on FirebaseException catch (error) {
      throw AiCallableException(code: error.code, message: error.message);
    }
  }
}

class AiProxyService {
  AiProxyService({AiCallableClient? client}) {
    _client = client;
  }

  AiCallableClient? _client;

  Future<Map<String, Object?>> generateMealPlan({
    required UserProfile profile,
    int days = 7,
    String locale = 'fr-FR',
  }) {
    return _callAndRequireMap(
      name: 'generateMealPlan',
      requiredKey: 'plan',
      data: {'profile': profile.toJson(), 'days': days, 'locale': locale},
    );
  }

  Future<Map<String, Object?>> replaceMeal({
    required UserProfile profile,
    required Meal currentMeal,
    required Map<String, Object?> planContext,
    String locale = 'fr-FR',
  }) {
    return _callAndRequireMap(
      name: 'replaceMeal',
      requiredKey: 'meal',
      data: {
        'profile': profile.toJson(),
        'currentMeal': currentMeal.toJson(),
        'planContext': planContext,
        'locale': locale,
      },
    );
  }

  Future<Map<String, Object?>> _callAndRequireMap({
    required String name,
    required String requiredKey,
    required Map<String, Object?> data,
  }) async {
    try {
      final payload = await _callableClient.call(name, data);
      final json = _asJsonMap(payload);
      if (json == null || json[requiredKey] is! Map) {
        throw const AiProxyException(
          code: 'invalid-response',
          message: 'Réponse IA invalide.',
        );
      }
      return json;
    } on AiCallableException catch (error) {
      throw AiProxyException(
        code: error.code,
        message: _messageForCode(error.code),
      );
    }
  }

  AiCallableClient get _callableClient {
    return _client ??= FirebaseAiCallableClient();
  }

  Map<String, Object?>? _asJsonMap(Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }

    if (value is Map) {
      return value.cast<String, Object?>();
    }

    return null;
  }

  String _messageForCode(String code) {
    return switch (code) {
      'unauthenticated' => 'Connectez-vous pour utiliser la génération IA.',
      'resource-exhausted' => 'Quota IA temporairement atteint.',
      'invalid-argument' => 'Demande IA invalide.',
      'not-found' ||
      'failed-precondition' => 'Génération IA momentanément indisponible.',
      'unavailable' ||
      'network-request-failed' => 'Génération IA momentanément indisponible.',
      'internal' => 'Génération IA momentanément indisponible.',
      _ => 'Service IA indisponible pour le moment.',
    };
  }
}

class AiCallableException implements Exception {
  const AiCallableException({required this.code, this.message});

  final String code;
  final String? message;

  @override
  String toString() => 'AiCallableException($code, $message)';
}

class AiProxyException implements Exception {
  const AiProxyException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => message;
}

class AiQuotaUsage {
  const AiQuotaUsage({
    required this.periodKey,
    required this.limit,
    required this.used,
    required this.remaining,
  });

  final String periodKey;
  final int limit;
  final int used;
  final int remaining;

  static AiQuotaUsage? maybeFromJson(Object? value) {
    if (value is! Map) {
      return null;
    }

    final json = value.cast<String, Object?>();
    final periodKey = json['periodKey'];
    final limit = json['limit'];
    final used = json['used'];
    final remaining = json['remaining'];

    if (periodKey is! String ||
        periodKey.isEmpty ||
        limit is! int ||
        used is! int ||
        remaining is! int) {
      return null;
    }

    return AiQuotaUsage(
      periodKey: periodKey,
      limit: limit,
      used: used,
      remaining: remaining,
    );
  }
}
