import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/domain/models/profile_preferences.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  group('ProfileViewModel', () {
    test('loads saved profile preferences into a data state', () async {
      final viewModel = ProfileViewModel(
        preferencesRepository: _SuccessfulPreferencesRepository(),
      );

      expect(viewModel.profileState, isA<ViewLoading<ProfilePreferences>>());

      await Future<void>.delayed(Duration.zero);

      final state = viewModel.profileState;
      expect(state, isA<ViewData<ProfilePreferences>>());
      final data = (state as ViewData<ProfilePreferences>).data;
      expect(data.profile.currentWeightKg, 82.5);
      expect(data.preferenceItems.first.value, 'Perdre du poids');
      expect(data.profileNeedsPlanRegeneration, isTrue);
    });

    test('exposes an error state when profile loading fails', () async {
      final viewModel = ProfileViewModel(
        preferencesRepository: _ThrowingPreferencesRepository(),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.profileState,
        isA<ViewError<ProfilePreferences>>().having(
          (state) => state.message,
          'message',
          'Aucun profil nutritionnel sauvegardé.',
        ),
      );
    });

    test('hides unexpected loading errors behind a generic message', () async {
      final viewModel = ProfileViewModel(
        preferencesRepository: _ThrowingPreferencesRepository(
          exception: StateError('debug profile failure'),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.profileState,
        isA<ViewError<ProfilePreferences>>().having(
          (state) => state.message,
          'message',
          'Une erreur est survenue. Réessayez dans un instant.',
        ),
      );
    });
  });
}

const _profile = UserProfile(
  goal: NutritionGoal.loseWeight,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Cacahuètes'],
  customAversions: ['Olives'],
  activityLevel: ActivityLevel.moderatelyActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

class _SuccessfulPreferencesRepository extends PreferencesRepository {
  _SuccessfulPreferencesRepository()
    : super(localDataStore: FakeLocalDataStore());

  @override
  Future<ProfilePreferences> getProfilePreferences() async {
    return const ProfilePreferences(
      profile: _profile,
      preferenceItems: [
        PreferenceItem(
          title: 'Objectifs santé',
          value: 'Perdre du poids',
          iconName: 'target',
          colorToken: 'info',
        ),
      ],
      dailyTargetCalories: 1850,
      profileNeedsPlanRegeneration: true,
    );
  }
}

class _ThrowingPreferencesRepository extends PreferencesRepository {
  _ThrowingPreferencesRepository({
    this.exception = const ProfilePreferencesUnavailableException(
      'Aucun profil nutritionnel sauvegardé.',
    ),
  }) : super(localDataStore: FakeLocalDataStore());

  final Object exception;

  @override
  Future<ProfilePreferences> getProfilePreferences() async {
    throw exception;
  }
}
