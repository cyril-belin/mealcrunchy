import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';

class DailyMealPlanScreen extends StatelessWidget {
  const DailyMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealPlanViewModel>();
    final mealsState = viewModel.mealsState;
    final summaryState = viewModel.summaryState;

    return switch ((mealsState, summaryState)) {
      (ViewLoading<List<Meal>>(), _) ||
      (_, ViewLoading<NutritionSummary>()) => const AppScaffold(
        scrollable: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      (ViewError<List<Meal>>(message: final message), _) => _ErrorScaffold(
        message: message,
        onRetry: viewModel.load,
      ),
      (_, ViewError<NutritionSummary>(message: final message)) =>
        _ErrorScaffold(message: message, onRetry: viewModel.load),
      (
        ViewData<List<Meal>>(data: final meals),
        ViewData<NutritionSummary>(data: final summary),
      ) =>
        _MealPlanContent(
          meals: meals,
          summary: summary,
          dayLabel: viewModel.currentDayLabel,
          isMealConsumed: viewModel.isMealConsumed,
          onMealConsumedChanged: viewModel.setMealConsumed,
        ),
    };
  }
}

class _MealPlanContent extends StatelessWidget {
  const _MealPlanContent({
    required this.meals,
    required this.summary,
    required this.dayLabel,
    required this.isMealConsumed,
    required this.onMealConsumedChanged,
  });

  final List<Meal> meals;
  final NutritionSummary summary;
  final String dayLabel;
  final bool Function(String mealId) isMealConsumed;
  final Future<bool> Function(String mealId, {required bool consumed})
  onMealConsumedChanged;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      'Votre plan IA',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.go(AppRoutes.profile),
                icon: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text('JD', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SoftCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Objectif quotidien',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${summary.consumedCalories} / ${summary.targetCalories} kcal',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: summary.progress,
                        strokeWidth: 6,
                        backgroundColor: AppColors.surfaceVariant,
                        color: AppColors.primary,
                      ),
                      Center(
                        child: Text(
                          '${(summary.progress * 100).round()}%',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Repas prevus',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                'Optimisé par IA',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...meals.map(
            (meal) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _MealCard(
                meal: meal,
                consumed: isMealConsumed(meal.id),
                onConsumedChanged: (consumed) async {
                  final messenger = ScaffoldMessenger.of(context);
                  final success = await onMealConsumedChanged(
                    meal.id,
                    consumed: consumed,
                  );
                  if (!success) {
                    messenger
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Impossible d\'enregistrer le suivi. Reessayez.',
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
          SoftCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repartition des macros',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Protéines ${summary.proteinPercent}%  -  Glucides ${summary.carbsPercent}%  -  Lipides ${summary.fatPercent}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: summary.proteinPercent / 100,
                    strokeWidth: 8,
                    color: AppColors.primary,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.generatingPlan),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Régénérer le plan IA'),
          ),
        ],
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message, required this.onRetry});

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
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger le plan.',
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
              onPressed: () {
                onRetry();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.meal,
    required this.consumed,
    required this.onConsumedChanged,
  });

  final Meal meal;
  final bool consumed;
  final ValueChanged<bool> onConsumedChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('meal-card-${meal.id}'),
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.go(AppRoutes.mealDetailsFor(meal.id)),
      child: SoftCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.typeLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.accent),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${meal.calories} kcal  -  P ${meal.protein}g  G ${meal.carbs}g  L ${meal.fat}g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  key: ValueKey('meal-consumed-checkbox-${meal.id}'),
                  value: consumed,
                  activeColor: AppColors.primary,
                  onChanged: (value) => onConsumedChanged(value ?? false),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
