T readJsonField<T>(Map<String, Object?> json, String field) {
  final value = json[field];
  if (value is T) {
    return value;
  }

  throw FormatException('Missing or invalid field "$field".');
}

List<String> readStringList(Map<String, Object?> json, String field) {
  final value = json[field];
  if (value is List) {
    try {
      return List<String>.from(value);
    } on TypeError {
      throw FormatException('Missing or invalid field "$field".');
    }
  }

  throw FormatException('Missing or invalid field "$field".');
}
