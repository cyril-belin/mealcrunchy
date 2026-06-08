import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';

class ShoppingListRepository {
  const ShoppingListRepository({required this.localDataStore});

  final LocalDataStore localDataStore;

  Future<List<ShoppingListItem>> getShoppingList() async {
    final savedItems = await localDataStore.loadShoppingList();
    if (savedItems.isNotEmpty) {
      return savedItems;
    }

    return regenerateFromActivePlan();
  }

  Future<List<ShoppingListItem>> regenerateFromActivePlan() async {
    final plan = await localDataStore.loadActiveMealPlan();
    if (plan == null) {
      throw const ShoppingListUnavailableException(
        'Aucun plan IA actif. Générez un plan pour créer la liste de courses.',
      );
    }

    final existingItems = await localDataStore.loadShoppingList();
    final checkedById = {
      for (final item in existingItems) item.id: item.checked,
    };
    final itemsById = <String, ShoppingListItem>{};

    for (final day in plan.days) {
      for (final meal in day.meals) {
        for (final ingredient in meal.ingredients) {
          final parsed = _ShoppingIngredient.parse(ingredient);
          if (parsed == null) {
            continue;
          }

          itemsById.putIfAbsent(parsed.id, () {
            return ShoppingListItem(
              id: parsed.id,
              name: parsed.name,
              quantity: parsed.quantity,
              category: 'Autres',
              checked: checkedById[parsed.id] ?? false,
            );
          });
        }
      }
    }

    final items = itemsById.values.toList(growable: false)
      ..sort((left, right) {
        final categoryCompare = left.category.compareTo(right.category);
        if (categoryCompare != 0) {
          return categoryCompare;
        }
        return left.name.toLowerCase().compareTo(right.name.toLowerCase());
      });
    await localDataStore.saveShoppingList(items);
    return items;
  }

  Future<List<ShoppingListItem>> setItemChecked(
    String id, {
    required bool checked,
  }) async {
    final items = await getShoppingList();
    final updatedItems = items
        .map((item) {
          if (item.id != id) {
            return item;
          }
          return item.copyWith(checked: checked);
        })
        .toList(growable: false);
    await localDataStore.saveShoppingList(updatedItems);
    return updatedItems;
  }
}

class ShoppingListUnavailableException implements Exception {
  const ShoppingListUnavailableException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _ShoppingIngredient {
  const _ShoppingIngredient({
    required this.id,
    required this.name,
    required this.quantity,
  });

  static final RegExp _spaces = RegExp(r'\s+');
  static final RegExp _leadingQuantity = RegExp(
    r'^(\d+(?:[,.]\d+)?(?:\s*(?:g|kg|ml|cl|l))?)\s+(.+)$',
    caseSensitive: false,
  );

  final String id;
  final String name;
  final String quantity;

  static _ShoppingIngredient? parse(String rawIngredient) {
    final cleaned = rawIngredient.trim().replaceAll(_spaces, ' ');
    if (cleaned.isEmpty) {
      return null;
    }

    var name = cleaned;
    var quantity = '';
    final quantityMatch = _leadingQuantity.firstMatch(cleaned);
    if (quantityMatch != null) {
      quantity = quantityMatch.group(1) ?? '';
      name = quantityMatch.group(2) ?? cleaned;
    }

    final id = name.trim().replaceAll(_spaces, ' ').toLowerCase();
    if (id.isEmpty) {
      return null;
    }

    return _ShoppingIngredient(id: id, name: name.trim(), quantity: quantity);
  }
}
