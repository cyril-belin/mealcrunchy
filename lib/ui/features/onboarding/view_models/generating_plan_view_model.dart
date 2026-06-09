import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/observability_service.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/ui/core/state/view_error_message.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class GeneratingPlanViewModel extends ChangeNotifier {
  GeneratingPlanViewModel({
    required this._mealPlanRepository,
    required this._localDataStore,
    ObservabilityService? observabilityService,
  }) : _observabilityService =
           observabilityService ?? const NoopObservabilityService();

  final MealPlanRepository _mealPlanRepository;
  final LocalDataStore _localDataStore;
  final ObservabilityService _observabilityService;

  ViewState<MealPlan> state = const ViewLoading();

  AiQuotaUsage? get planGenerationUsage =>
      _mealPlanRepository.lastPlanGenerationUsage;

  Future<void> generate() async {
    state = const ViewLoading();
    notifyListeners();
    await _track(_observabilityService.logAiPlanGenerationStarted);

    try {
      final profile = await _localDataStore.loadUserProfile();
      if (profile == null) {
        state = const ViewError(
          'Profil nutritionnel introuvable. Reprenez l\'onboarding.',
        );
        await _track(
          () => _observabilityService.logAiPlanGenerationFailed(
            code: 'missing-profile',
          ),
        );
      } else {
        final plan = await _mealPlanRepository.generateActiveMealPlan(profile);
        state = ViewData(plan);
        await _track(
          () => _observabilityService.logAiPlanGenerationSucceeded(
            usage: planGenerationUsage,
          ),
        );
      }
    } on AiProxyException catch (error, stackTrace) {
      state = ViewError(error.message);
      await _track(
        () => _observabilityService.logAiPlanGenerationFailed(code: error.code),
      );
      await _track(
        () => _observabilityService.recordError(
          error,
          stackTrace,
          reason: 'ai_plan_generation_failed',
        ),
      );
    } catch (error, stackTrace) {
      state = const ViewError(unexpectedViewErrorMessage);
      await _track(() => _observabilityService.logAiPlanGenerationFailed());
      await _track(
        () => _observabilityService.recordError(
          error,
          stackTrace,
          reason: 'ai_plan_generation_failed',
        ),
      );
    }

    notifyListeners();
  }

  Future<void> _track(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Observability failures must never block meal plan generation.
    }
  }
}
