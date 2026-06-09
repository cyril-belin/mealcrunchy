import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';

abstract class ObservabilityService {
  NavigatorObserver? createNavigatorObserver();

  Future<void> logAiPlanGenerationStarted();

  Future<void> logAiPlanGenerationSucceeded({AiQuotaUsage? usage});

  Future<void> logAiPlanGenerationFailed({String? code});

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  });
}

class NoopObservabilityService implements ObservabilityService {
  const NoopObservabilityService();

  @override
  NavigatorObserver? createNavigatorObserver() => null;

  @override
  Future<void> logAiPlanGenerationStarted() async {}

  @override
  Future<void> logAiPlanGenerationSucceeded({AiQuotaUsage? usage}) async {}

  @override
  Future<void> logAiPlanGenerationFailed({String? code}) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {}
}

class FirebaseObservabilityService implements ObservabilityService {
  FirebaseObservabilityService({
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  }) : _analytics = analytics ?? FirebaseAnalytics.instance,
       _crashlytics = kIsWeb
           ? null
           : crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics? _crashlytics;

  @override
  NavigatorObserver createNavigatorObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  @override
  Future<void> logAiPlanGenerationStarted() {
    return _analytics.logEvent(name: 'ai_plan_generation_started');
  }

  @override
  Future<void> logAiPlanGenerationSucceeded({AiQuotaUsage? usage}) {
    return _analytics.logEvent(
      name: 'ai_plan_generation_succeeded',
      parameters: _usageParameters(usage),
    );
  }

  @override
  Future<void> logAiPlanGenerationFailed({String? code}) {
    return _analytics.logEvent(
      name: 'ai_plan_generation_failed',
      parameters: {'code': code ?? 'unknown'},
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    await _crashlytics?.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  Map<String, Object>? _usageParameters(AiQuotaUsage? usage) {
    if (usage == null) {
      return null;
    }

    return {
      'period_key': usage.periodKey,
      'limit': usage.limit,
      'used': usage.used,
      'remaining': usage.remaining,
    };
  }
}
