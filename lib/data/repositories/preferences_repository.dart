import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/domain/models/profile_preferences.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class PreferencesRepository {
  const PreferencesRepository({required this.localDataStore});

  final LocalDataStore localDataStore;

  Future<ProfilePreferences> getProfilePreferences() async {
    final profile = await localDataStore.loadUserProfile();
    if (profile == null) {
      throw const ProfilePreferencesUnavailableException(
        'Aucun profil nutritionnel sauvegardé.',
      );
    }

    final plan = await localDataStore.loadActiveMealPlan();
    final needsPlanRegeneration = await localDataStore
        .loadProfileNeedsPlanRegeneration();
    return ProfilePreferences(
      profile: profile,
      preferenceItems: _preferencesFromProfile(profile),
      dailyTargetCalories: plan?.summary.targetCalories,
      profileNeedsPlanRegeneration: needsPlanRegeneration,
    );
  }

  List<PreferenceItem> _preferencesFromProfile(UserProfile profile) {
    final allergyAndAversionValues = [
      ...profile.allergies,
      ...profile.customAversions,
    ];

    return [
      PreferenceItem(
        title: 'Objectifs santé',
        value: profile.goal.value,
        iconName: 'target',
        colorToken: 'info',
      ),
      PreferenceItem(
        title: 'Régime alimentaire',
        value: profile.dietStyle.value,
        iconName: 'restaurant',
        colorToken: 'success',
      ),
      PreferenceItem(
        title: 'Allergies et aversions',
        value: _joinOrFallback(allergyAndAversionValues, 'Aucune'),
        iconName: 'warning',
        colorToken: 'error',
      ),
      PreferenceItem(
        title: 'Niveau d\'activité',
        value: profile.activityLevel.value,
        iconName: 'fitness',
        colorToken: 'warning',
      ),
      PreferenceItem(
        title: 'Horaires de repas',
        value: _joinOrFallback(profile.mealTiming, 'Non renseignés'),
        iconName: 'timer',
        colorToken: 'info',
      ),
      PreferenceItem(
        title: 'Mensurations',
        value:
            '${profile.age} ans - ${profile.heightCm} cm - '
            '${profile.currentWeightKg} kg vers ${profile.targetWeightKg} kg',
        iconName: 'straightener',
        colorToken: 'primary',
      ),
    ];
  }

  String _joinOrFallback(List<String> values, String fallback) {
    if (values.isEmpty) {
      return fallback;
    }

    return values.join(' - ');
  }
}

class ProfilePreferencesUnavailableException implements Exception {
  const ProfilePreferencesUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}
