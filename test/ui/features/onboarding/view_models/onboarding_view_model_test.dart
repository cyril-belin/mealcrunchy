import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';

void main() {
  group('OnboardingViewModel', () {
    test('selects a single primary goal', () {
      final viewModel = OnboardingViewModel();

      viewModel.selectGoal('Prendre du muscle');

      expect(viewModel.selectedGoalTitle, 'Prendre du muscle');
      expect(viewModel.goals.where((option) => option.selected), hasLength(1));
    });

    test('toggles allergies as a multi-selection', () {
      final viewModel = OnboardingViewModel();

      viewModel.toggleAllergy('Cacahuetes');
      viewModel.toggleAllergy('Gluten');

      expect(
        viewModel.selectedAllergyTitles,
        containsAll(<String>['Produits laitiers', 'Cacahuetes', 'Gluten']),
      );

      viewModel.toggleAllergy('Cacahuetes');

      expect(viewModel.selectedAllergyTitles, isNot(contains('Cacahuetes')));
      expect(viewModel.selectedAllergyTitles, contains('Gluten'));
    });

    test('refuses to build a profile when required metrics are missing', () {
      final viewModel = OnboardingViewModel();

      expect(viewModel.isProfileValid, isFalse);
      expect(viewModel.buildProfile(), isNull);
      expect(viewModel.profileValidationMessage, 'Renseignez vos mesures.');
    });

    test('builds a valid nutrition profile with selections and metrics', () {
      final viewModel = OnboardingViewModel()
        ..selectGoal('Prendre du muscle')
        ..selectDietStyle('Mediterraneen')
        ..selectActivityLevel('Tres actif')
        ..toggleAllergy('Gluten')
        ..updateCustomAversions('coriandre, champignons')
        ..updateAge('32')
        ..updateHeightCm('181')
        ..updateCurrentWeightKg('82.5')
        ..updateTargetWeightKg('86');

      final profile = viewModel.buildProfile();

      expect(profile, isA<UserProfile>());
      expect(profile?.goal, 'Prendre du muscle');
      expect(profile?.dietStyle, 'Mediterraneen');
      expect(profile?.activityLevel, 'Tres actif');
      expect(profile?.allergies, contains('Gluten'));
      expect(profile?.customAversions, <String>['coriandre', 'champignons']);
      expect(profile?.age, 32);
      expect(profile?.heightCm, 181);
      expect(profile?.currentWeightKg, 82.5);
      expect(profile?.targetWeightKg, 86);
    });

    test('saves a valid profile to local storage on submit', () async {
      final localDataStore = _SavingLocalDataStore();
      final viewModel = OnboardingViewModel(localDataStore: localDataStore)
        ..updateAge('32')
        ..updateHeightCm('181')
        ..updateCurrentWeightKg('82.5')
        ..updateTargetWeightKg('86');

      final profile = await viewModel.submitProfile();

      expect(profile, isNotNull);
      expect(localDataStore.savedProfile?.age, 32);
    });
  });
}

class _SavingLocalDataStore implements LocalDataStore {
  UserProfile? savedProfile;

  @override
  Future<LocalMealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<void> saveActiveMealPlan({
    required List<Meal> meals,
    required NutritionSummary summary,
  }) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    savedProfile = profile;
  }
}
