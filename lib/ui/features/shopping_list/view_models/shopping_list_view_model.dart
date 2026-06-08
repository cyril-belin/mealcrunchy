import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';

class ShoppingListViewModel extends ChangeNotifier {
  ShoppingListViewModel({required this.shoppingListRepository}) {
    load();
  }

  final ShoppingListRepository shoppingListRepository;

  ViewState<List<ShoppingListItem>> itemsState = const ViewLoading();

  Future<void> load() async {
    itemsState = const ViewLoading();
    notifyListeners();

    try {
      final items = await shoppingListRepository.getShoppingList();
      itemsState = ViewData(items);
    } catch (error) {
      itemsState = ViewError(error.toString());
    }

    notifyListeners();
  }

  Future<bool> setItemChecked(String id, {required bool checked}) async {
    final items = switch (itemsState) {
      ViewData<List<ShoppingListItem>>(data: final data) => data,
      _ => null,
    };
    if (items == null) {
      return false;
    }

    final optimisticItems = items
        .map((item) {
          if (item.id != id) {
            return item;
          }
          return item.copyWith(checked: checked);
        })
        .toList(growable: false);
    itemsState = ViewData(optimisticItems);
    notifyListeners();

    try {
      final savedItems = await shoppingListRepository.setItemChecked(
        id,
        checked: checked,
      );
      itemsState = ViewData(savedItems);
      notifyListeners();
      return true;
    } catch (_) {
      itemsState = ViewData(items);
      notifyListeners();
      return false;
    }
  }
}
