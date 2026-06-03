import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this.preferencesRepository}) {
    load();
  }

  final PreferencesRepository preferencesRepository;

  ViewState<List<PreferenceItem>> preferencesState = const ViewLoading();

  Future<void> load() async {
    preferencesState = const ViewLoading();
    notifyListeners();

    try {
      final preferences = await preferencesRepository.getPreferences();
      preferencesState = ViewData(preferences);
    } catch (error) {
      preferencesState = ViewError(error.toString());
    }

    notifyListeners();
  }
}
