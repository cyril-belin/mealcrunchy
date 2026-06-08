import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/ui/features/shopping_list/view_models/shopping_list_view_model.dart';
import 'package:mealcrunchy/ui/features/shopping_list/views/shopping_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/fake_local_data_store.dart';

void main() {
  testWidgets('displays grouped shopping items and toggles checkboxes', (
    tester,
  ) async {
    final store = FakeLocalDataStore()
      ..shoppingList = const [
        ShoppingListItem(
          id: 'avocat',
          name: 'Avocat',
          quantity: '',
          category: 'Autres',
          checked: false,
        ),
        ShoppingListItem(
          id: 'oeufs',
          name: 'oeufs',
          quantity: '2',
          category: 'Autres',
          checked: false,
        ),
      ];
    final viewModel = ShoppingListViewModel(
      shoppingListRepository: ShoppingListRepository(localDataStore: store),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<ShoppingListViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: ShoppingListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Liste de courses'), findsOneWidget);
    expect(find.text('Autres'), findsOneWidget);
    expect(find.text('Avocat'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('shopping-item-checkbox-avocat')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('shopping-item-checkbox-avocat')),
    );
    await tester.pumpAndSettle();

    expect(
      store.shoppingList.singleWhere((item) => item.id == 'avocat').checked,
      isTrue,
    );
  });
}
