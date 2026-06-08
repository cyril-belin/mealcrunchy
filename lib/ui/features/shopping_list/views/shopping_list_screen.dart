import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/shopping_list/view_models/shopping_list_view_model.dart';
import 'package:provider/provider.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ShoppingListViewModel>();

    return switch (viewModel.itemsState) {
      ViewLoading<List<ShoppingListItem>>() => const AppScaffold(
        scrollable: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      ViewError<List<ShoppingListItem>>(message: final message) =>
        _ShoppingListError(message: message, onRetry: viewModel.load),
      ViewData<List<ShoppingListItem>>(data: final items) =>
        _ShoppingListContent(
          items: items,
          onItemCheckedChanged: viewModel.setItemChecked,
        ),
    };
  }
}

class _ShoppingListContent extends StatelessWidget {
  const _ShoppingListContent({
    required this.items,
    required this.onItemCheckedChanged,
  });

  final List<ShoppingListItem> items;
  final Future<bool> Function(String id, {required bool checked})
  onItemCheckedChanged;

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupByCategory(items);

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.mealPlan),
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Retour',
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Liste de courses',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            const SoftCard(
              child: Text('Aucun ingrédient à acheter pour le moment.'),
            )
          else
            ...groupedItems.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ShoppingCategory(
                  category: entry.key,
                  items: entry.value,
                  onItemCheckedChanged: onItemCheckedChanged,
                ),
              );
            }),
        ],
      ),
    );
  }

  Map<String, List<ShoppingListItem>> _groupByCategory(
    List<ShoppingListItem> items,
  ) {
    final groupedItems = <String, List<ShoppingListItem>>{};
    for (final item in items) {
      groupedItems
          .putIfAbsent(item.category, () => <ShoppingListItem>[])
          .add(item);
    }
    return groupedItems;
  }
}

class _ShoppingCategory extends StatelessWidget {
  const _ShoppingCategory({
    required this.category,
    required this.items,
    required this.onItemCheckedChanged,
  });

  final String category;
  final List<ShoppingListItem> items;
  final Future<bool> Function(String id, {required bool checked})
  onItemCheckedChanged;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...items.map((item) {
            return _ShoppingItemRow(
              item: item,
              onItemCheckedChanged: onItemCheckedChanged,
            );
          }),
        ],
      ),
    );
  }
}

class _ShoppingItemRow extends StatelessWidget {
  const _ShoppingItemRow({
    required this.item,
    required this.onItemCheckedChanged,
  });

  final ShoppingListItem item;
  final Future<bool> Function(String id, {required bool checked})
  onItemCheckedChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('shopping-item-row-${item.id}'),
      onTap: () => _saveChecked(context, !item.checked),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            Checkbox(
              key: ValueKey('shopping-item-checkbox-${item.id}'),
              value: item.checked,
              activeColor: AppColors.primary,
              onChanged: (value) => _saveChecked(context, value ?? false),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                item.name,
                style: item.checked
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.secondaryText,
                      )
                    : null,
              ),
            ),
            if (item.quantity.isNotEmpty) ...[
              const SizedBox(width: 12),
              Text(
                item.quantity,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveChecked(BuildContext context, bool checked) async {
    final messenger = ScaffoldMessenger.of(context);
    final success = await onItemCheckedChanged(item.id, checked: checked);
    if (!success) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'enregistrer la liste. Réessayez.'),
          ),
        );
    }
  }
}

class _ShoppingListError extends StatelessWidget {
  const _ShoppingListError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'Liste indisponible',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.go(AppRoutes.generatingPlan),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Générer un plan'),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
