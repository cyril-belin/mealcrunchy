import 'package:mealcrunchy/domain/models/json_readers.dart';

class PreferenceItem {
  const PreferenceItem({
    required this.title,
    required this.value,
    required this.iconName,
    required this.colorToken,
  });

  final String title;
  final String value;
  final String iconName;
  final String colorToken;

  factory PreferenceItem.fromJson(Map<String, Object?> json) {
    return PreferenceItem(
      title: readJsonField<String>(json, 'title'),
      value: readJsonField<String>(json, 'value'),
      iconName: readJsonField<String>(json, 'iconName'),
      colorToken: readJsonField<String>(json, 'colorToken'),
    );
  }
}
