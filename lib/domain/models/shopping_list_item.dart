import 'package:mealcrunchy/domain/models/json_readers.dart';

class ShoppingListItem {
  const ShoppingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.checked,
  });

  final String id;
  final String name;
  final String quantity;
  final String category;
  final bool checked;

  ShoppingListItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? category,
    bool? checked,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      checked: checked ?? this.checked,
    );
  }

  factory ShoppingListItem.fromJson(Map<String, Object?> json) {
    return ShoppingListItem(
      id: readJsonField<String>(json, 'id'),
      name: readJsonField<String>(json, 'name'),
      quantity: readJsonField<String>(json, 'quantity'),
      category: readJsonField<String>(json, 'category'),
      checked: readJsonField<bool>(json, 'checked'),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'checked': checked,
    };
  }
}
