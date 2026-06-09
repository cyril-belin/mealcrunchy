import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/features/shopping_list/view_models/shopping_list_view_model.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  group('ShoppingListViewModel', () {
    test('loads persisted shopping list items', () async {
      final store = FakeLocalDataStore()
        ..shoppingList = const [
          ShoppingListItem(
            id: 'avocat',
            name: 'Avocat',
            quantity: '',
            category: 'Autres',
            checked: false,
          ),
        ];
      final viewModel = ShoppingListViewModel(
        shoppingListRepository: ShoppingListRepository(localDataStore: store),
      );

      expect(viewModel.itemsState, isA<ViewLoading<List<ShoppingListItem>>>());
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.itemsState;
      expect(state, isA<ViewData<List<ShoppingListItem>>>());
      expect(
        (state as ViewData<List<ShoppingListItem>>).data.single.name,
        'Avocat',
      );
    });

    test('checks and unchecks an item with persistence', () async {
      final store = FakeLocalDataStore()
        ..shoppingList = const [
          ShoppingListItem(
            id: 'avocat',
            name: 'Avocat',
            quantity: '',
            category: 'Autres',
            checked: false,
          ),
        ];
      final viewModel = ShoppingListViewModel(
        shoppingListRepository: ShoppingListRepository(localDataStore: store),
      );
      await Future<void>.delayed(Duration.zero);

      final checked = await viewModel.setItemChecked('avocat', checked: true);
      final unchecked = await viewModel.setItemChecked(
        'avocat',
        checked: false,
      );

      expect(checked, isTrue);
      expect(unchecked, isTrue);
      expect(store.shoppingList.single.checked, isFalse);
    });

    test('hides unexpected loading errors behind a generic message', () async {
      final viewModel = ShoppingListViewModel(
        shoppingListRepository: _ThrowingShoppingListRepository(
          StateError('debug shopping list failure'),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(
        viewModel.itemsState,
        isA<ViewError<List<ShoppingListItem>>>().having(
          (state) => state.message,
          'message',
          'Une erreur est survenue. Réessayez dans un instant.',
        ),
      );
    });
  });
}

class _ThrowingShoppingListRepository extends ShoppingListRepository {
  _ThrowingShoppingListRepository(this.exception)
    : super(localDataStore: FakeLocalDataStore());

  final Object exception;

  @override
  Future<List<ShoppingListItem>> getShoppingList() async => throw exception;
}
