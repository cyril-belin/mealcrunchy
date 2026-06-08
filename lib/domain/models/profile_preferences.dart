import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class ProfilePreferences {
  const ProfilePreferences({
    required this.profile,
    required this.preferenceItems,
    required this.dailyTargetCalories,
    required this.profileNeedsPlanRegeneration,
  });

  final UserProfile profile;
  final List<PreferenceItem> preferenceItems;
  final int? dailyTargetCalories;
  final bool profileNeedsPlanRegeneration;
}
