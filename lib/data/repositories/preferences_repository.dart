import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';

class PreferencesRepository {
  const PreferencesRepository({required this.contentService});

  final StaticDesignContentService contentService;

  Future<List<PreferenceItem>> getPreferences() async {
    final items = await contentService.fetchPreferenceItems();
    return items.map(PreferenceItem.fromJson).toList(growable: false);
  }
}
