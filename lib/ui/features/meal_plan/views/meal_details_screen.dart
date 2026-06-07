import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({required this.mealId, super.key});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealPlanViewModel>();
    final mealsState = viewModel.mealsState;

    return switch (mealsState) {
      ViewLoading<List<Meal>>() => const AppScaffold(
        scrollable: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      ViewError<List<Meal>>() => _MealStateScaffold(
        title: 'Impossible de charger ce repas.',
        message: 'Le détail du repas est temporairement indisponible.',
        actionLabel: 'Réessayer',
        actionIcon: Icons.refresh_rounded,
        onAction: viewModel.load,
      ),
      ViewData<List<Meal>>() => _MealDetailsContent(
        meal: viewModel.mealById(mealId),
        isReplacing: viewModel.replacingMealId == mealId,
        onReplaceMeal: () async {
          final success = await viewModel.replaceMeal(mealId);
          return success ? null : viewModel.replacementErrorMessage;
        },
      ),
    };
  }
}

class _MealDetailsContent extends StatelessWidget {
  const _MealDetailsContent({
    required this.meal,
    required this.isReplacing,
    required this.onReplaceMeal,
  });

  final Meal? meal;
  final bool isReplacing;
  final Future<String?> Function() onReplaceMeal;

  @override
  Widget build(BuildContext context) {
    final meal = this.meal;
    if (meal == null) {
      return _MealStateScaffold(
        title: 'Repas introuvable.',
        message: 'Ce repas n\'existe pas dans le plan actuel.',
        actionLabel: 'Retour au plan',
        actionIcon: Icons.arrow_back_rounded,
        onAction: () async => context.go(AppRoutes.mealPlan),
      );
    }

    return AppScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: AppColors.surface,
                child: Icon(
                  Icons.breakfast_dining_rounded,
                  size: 150,
                  color: AppColors.primary.withValues(alpha: 0.22),
                ),
              ),
              Positioned(
                left: 18,
                top: 18,
                child: _CircleButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }

                    context.go(AppRoutes.mealPlan);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        meal.typeLabel,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppColors.secondaryText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      meal.duration,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${meal.calories} kcal',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _MacroCard(
                        label: 'Protéines',
                        value: '${meal.protein}g',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MacroCard(
                        label: 'Glucides',
                        value: '${meal.carbs}g',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MacroCard(
                        label: 'Lipides',
                        value: '${meal.fat}g',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _IngredientList(meal: meal),
                const SizedBox(height: 26),
                _Instructions(meal: meal),
                const SizedBox(height: 26),
                ElevatedButton.icon(
                  onPressed: isReplacing
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final errorMessage = await onReplaceMeal();
                          if (!context.mounted) {
                            return;
                          }

                          messenger
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  errorMessage ?? 'Repas remplacé.',
                                ),
                              ),
                            );
                        },
                  icon: isReplacing
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome_rounded),
                  label: Text(isReplacing ? 'Remplacement...' : 'Remplacer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealStateScaffold extends StatelessWidget {
  const _MealStateScaffold({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final IconData actionIcon;
  final Future<void> Function() onAction;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.secondaryText,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              title,
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
            OutlinedButton.icon(
              onPressed: () {
                onAction();
              },
              icon: Icon(actionIcon),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _IngredientList extends StatelessWidget {
  const _IngredientList({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ingrédients', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...meal.ingredients.map(
          (ingredient) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: AppColors.success,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(ingredient)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions rapides',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...meal.instructions.indexed.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${entry.$1 + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(entry.$2)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
