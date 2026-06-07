import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class GeneratingPlanViewModel extends ChangeNotifier {
  GeneratingPlanViewModel({
    required this.mealPlanRepository,
    required this.localDataStore,
  });

  final MealPlanRepository mealPlanRepository;
  final LocalDataStore localDataStore;

  ViewState<MealPlan> state = const ViewLoading();

  Future<void> generate() async {
    state = const ViewLoading();
    notifyListeners();

    try {
      final profile = await localDataStore.loadUserProfile();
      if (profile == null) {
        state = const ViewError(
          'Profil nutritionnel introuvable. Reprenez l\'onboarding.',
        );
        notifyListeners();
        return;
      }

      final plan = await mealPlanRepository.generateActiveMealPlan(profile);
      state = ViewData(plan);
    } catch (error) {
      state = ViewError(error.toString());
    }

    notifyListeners();
  }
}
