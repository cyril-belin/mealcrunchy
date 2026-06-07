import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class PreferencesRepository {
  const PreferencesRepository({
    required this.contentService,
    this.localDataStore,
  });

  final StaticDesignContentService contentService;
  final LocalDataStore? localDataStore;

  Future<List<PreferenceItem>> getPreferences() async {
    final profile = await _loadLocalProfile();
    if (profile != null) {
      return _preferencesFromProfile(profile);
    }

    final items = await contentService.fetchPreferenceItems();
    return items.map(PreferenceItem.fromJson).toList(growable: false);
  }

  Future<UserProfile?> _loadLocalProfile() async {
    final localDataStore = this.localDataStore;
    if (localDataStore == null) {
      return null;
    }

    try {
      return localDataStore.loadUserProfile();
    } catch (_) {
      return null;
    }
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
