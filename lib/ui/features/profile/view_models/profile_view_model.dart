import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/domain/models/profile_preferences.dart';
import 'package:mealcrunchy/ui/core/state/view_error_message.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this.preferencesRepository}) {
    load();
  }

  final PreferencesRepository preferencesRepository;

  ViewState<ProfilePreferences> profileState = const ViewLoading();

  Future<void> load() async {
    profileState = const ViewLoading();
    notifyListeners();

    try {
      final preferences = await preferencesRepository.getProfilePreferences();
      profileState = ViewData(preferences);
    } on ProfilePreferencesUnavailableException catch (error) {
      profileState = ViewError(error.message);
    } catch (_) {
      profileState = const ViewError(unexpectedViewErrorMessage);
    }

    notifyListeners();
  }
}
