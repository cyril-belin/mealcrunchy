import 'package:flutter_test/flutter_test.dart';
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
  });
}
