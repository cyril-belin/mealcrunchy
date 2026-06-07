import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class GeneratingPlanViewModel extends ChangeNotifier {
  GeneratingPlanViewModel({
    required this._mealPlanRepository,
    required this._localDataStore,
  });

  final MealPlanRepository _mealPlanRepository;
  final LocalDataStore _localDataStore;

  ViewState<MealPlan> state = const ViewLoading();

  Future<void> generate() async {
    state = const ViewLoading();
    notifyListeners();

    try {
      final profile = await _localDataStore.loadUserProfile();
      if (profile == null) {
        state = const ViewError(
          'Profil nutritionnel introuvable. Reprenez l\'onboarding.',
        );
        notifyListeners();
        return;
      }

      final plan = await _mealPlanRepository.generateActiveMealPlan(profile);
      state = ViewData(plan);
    } catch (error) {
      state = ViewError(error.toString());
    }

    notifyListeners();
  }
}
