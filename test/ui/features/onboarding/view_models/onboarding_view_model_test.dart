import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';

void main() {
  group('OnboardingViewModel', () {
    test('selects a single primary goal', () {
      final viewModel = OnboardingViewModel(
        localDataStore: _SavingLocalDataStore(),
      );

      viewModel.selectGoal('Prendre du muscle');

      expect(viewModel.selectedGoalTitle, 'Prendre du muscle');
      expect(viewModel.goals.where((option) => option.selected), hasLength(1));
    });

    test('starts with no allergy pre-selected', () {
      final viewModel = OnboardingViewModel(
        localDataStore: _SavingLocalDataStore(),
      );

      expect(viewModel.selectedAllergyTitles, isEmpty);
    });

    test('toggles allergies as a multi-selection', () {
      final viewModel = OnboardingViewModel(
        localDataStore: _SavingLocalDataStore(),
      );

      viewModel.toggleAllergy('Cacahuètes');
      viewModel.toggleAllergy('Gluten');

      expect(
        viewModel.selectedAllergyTitles,
        containsAll(<String>['Cacahuètes', 'Gluten']),
      );

      viewModel.toggleAllergy('Cacahuètes');

      expect(viewModel.selectedAllergyTitles, isNot(contains('Cacahuètes')));
      expect(viewModel.selectedAllergyTitles, contains('Gluten'));
    });

    test('refuses to build a profile when required metrics are missing', () {
      final viewModel = OnboardingViewModel(
        localDataStore: _SavingLocalDataStore(),
      );

      expect(viewModel.isProfileValid, isFalse);
      expect(viewModel.buildProfile(), isNull);
      expect(viewModel.profileValidationMessage, 'Renseignez vos mesures.');
    });

    test('builds a valid nutrition profile with selections and metrics', () {
      final viewModel =
          OnboardingViewModel(localDataStore: _SavingLocalDataStore())
            ..selectGoal('Prendre du muscle')
            ..selectDietStyle('Méditerranéen')
            ..selectActivityLevel('Très actif')
            ..toggleAllergy('Gluten')
            ..updateCustomAversions('coriandre, champignons')
            ..updateAge('32')
            ..updateHeightCm('181')
            ..updateCurrentWeightKg('82.5')
            ..updateTargetWeightKg('86');

      final profile = viewModel.buildProfile();

      expect(profile, isA<UserProfile>());
      expect(profile?.goal, NutritionGoal.buildMuscle);
      expect(profile?.dietStyle, DietStyle.mediterranean);
      expect(profile?.activityLevel, ActivityLevel.veryActive);
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

    test(
      'prefills selections and metrics from the saved profile for editing',
      () async {
        final localDataStore = _SavingLocalDataStore(savedProfile: _profile);
        final viewModel = OnboardingViewModel(localDataStore: localDataStore);

        final started = await viewModel.startProfileEdit();

        expect(started, isTrue);
        expect(viewModel.isEditingProfile, isTrue);
        expect(viewModel.selectedGoalTitle, 'Prendre du muscle');
        expect(viewModel.selectedDietStyleTitle, 'Méditerranéen');
        expect(viewModel.selectedActivityLevelTitle, 'Très actif');
        expect(viewModel.selectedAllergyTitles, <String>['Gluten']);
        expect(viewModel.selectedMealTimingTitles, <String>[
          '3 repas classiques',
        ]);
        expect(viewModel.customAversionsInput, 'coriandre, champignons');
        expect(viewModel.ageInput, '32');
        expect(viewModel.heightCmInput, '181');
        expect(viewModel.currentWeightKgInput, '82.5');
        expect(viewModel.targetWeightKgInput, '86.0');
      },
    );

    test(
      'marks the active plan stale when an edited profile changes',
      () async {
        final localDataStore = _SavingLocalDataStore(savedProfile: _profile);
        final viewModel = OnboardingViewModel(localDataStore: localDataStore);

        await viewModel.startProfileEdit();
        viewModel.selectGoal('Maintenir');
        await viewModel.submitProfile();

        expect(localDataStore.profileNeedsPlanRegeneration, isTrue);
      },
    );

    test(
      'keeps the active plan fresh when an edited profile is unchanged',
      () async {
        final localDataStore = _SavingLocalDataStore(savedProfile: _profile);
        final viewModel = OnboardingViewModel(localDataStore: localDataStore);

        await viewModel.startProfileEdit();
        await viewModel.submitProfile();

        expect(localDataStore.profileNeedsPlanRegeneration, isFalse);
      },
    );
  });
}

const _profile = UserProfile(
  goal: NutritionGoal.buildMuscle,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Gluten'],
  customAversions: ['coriandre', 'champignons'],
  activityLevel: ActivityLevel.veryActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 181,
  currentWeightKg: 82.5,
  targetWeightKg: 86,
);

class _SavingLocalDataStore implements LocalDataStore {
  _SavingLocalDataStore({this.savedProfile});

  UserProfile? savedProfile;
  bool profileNeedsPlanRegeneration = false;

  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<UserProfile?> loadUserProfile() async => savedProfile;

  @override
  Future<bool> loadProfileNeedsPlanRegeneration() async {
    return profileNeedsPlanRegeneration;
  }

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    savedProfile = profile;
  }

  @override
  Future<void> saveProfileNeedsPlanRegeneration(bool value) async {
    profileNeedsPlanRegeneration = value;
  }
}
