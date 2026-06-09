import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/l10n/app_localizations.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/ai_quota_messages.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:provider/provider.dart';

class DailyMealPlanScreen extends StatelessWidget {
  const DailyMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealPlanViewModel>();
    final authViewModel = context.watch<AuthViewModel?>();
    final l10n = AppLocalizations.of(context);
    final mealsState = viewModel.mealsState;
    final summaryState = viewModel.summaryState;
    final accountInitials = _accountInitials(authViewModel?.account);

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
          dayLabel: l10n.todayDateLabel(viewModel.currentDayDateLabel),
          isMealConsumed: viewModel.isMealConsumed,
          onMealConsumedChanged: viewModel.setMealConsumed,
          replacingMealId: viewModel.replacingMealId,
          accountInitials: accountInitials,
          planGenerationQuotaMessage: remainingRegenerationsMessage(
            l10n,
            viewModel.planGenerationUsage,
          ),
          onReplaceMeal: (mealId) async {
            final success = await viewModel.replaceMeal(mealId);
            return success
                ? remainingReplacementsMessage(
                    l10n,
                    viewModel.mealReplacementUsage,
                    includeSuccessPrefix: true,
                  )
                : viewModel.replacementErrorMessage;
          },
        ),
    };
  }

  String _accountInitials(AuthAccount? account) {
    final displayName = account?.displayName?.trim();
    final source = displayName != null && displayName.isNotEmpty
        ? displayName
        : account?.email.split('@').first.trim();
    final cleanedSource = source?.trim();
    if (cleanedSource == null || cleanedSource.isEmpty) {
      return 'MC';
    }

    final words = cleanedSource
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    if (words.length >= 2) {
      return '${words.first.characters.first}${words[1].characters.first}'
          .toUpperCase();
    }

    final compact = cleanedSource.replaceAll(RegExp(r'[^A-Za-zÀ-ÿ0-9]'), '');
    if (compact.isEmpty) {
      return 'MC';
    }

    return compact.characters.take(2).toString().toUpperCase();
  }
}

class _MealPlanContent extends StatelessWidget {
  const _MealPlanContent({
    required this.meals,
    required this.summary,
    required this.dayLabel,
    required this.isMealConsumed,
    required this.onMealConsumedChanged,
    required this.replacingMealId,
    required this.accountInitials,
    required this.planGenerationQuotaMessage,
    required this.onReplaceMeal,
  });

  final List<Meal> meals;
  final NutritionSummary summary;
  final String dayLabel;
  final bool Function(String mealId) isMealConsumed;
  final Future<bool> Function(String mealId, {required bool consumed})
  onMealConsumedChanged;
  final String? replacingMealId;
  final String accountInitials;
  final String? planGenerationQuotaMessage;
  final Future<String?> Function(String mealId) onReplaceMeal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                      l10n.mealPlanTitle,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.go(AppRoutes.profile),
                icon: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    accountInitials,
                    style: const TextStyle(color: Colors.white),
                  ),
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
                        l10n.dailyGoalTitle,
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
                  l10n.plannedMealsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                l10n.aiOptimizedLabel,
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
                isReplacing: replacingMealId == meal.id,
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
                        SnackBar(content: Text(l10n.trackingSaveError)),
                      );
                  }
                },
                onReplaceMeal: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final errorMessage = await onReplaceMeal(meal.id);
                  if (!context.mounted) {
                    return;
                  }

                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(errorMessage ?? l10n.mealReplaced),
                      ),
                    );
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
                        l10n.macroDistributionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.macroDistributionSummary(
                          summary.proteinPercent,
                          summary.carbsPercent,
                          summary.fatPercent,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                _MacroRing(
                  proteinPercent: summary.proteinPercent,
                  carbsPercent: summary.carbsPercent,
                  fatPercent: summary.fatPercent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.shoppingList),
            icon: const Icon(Icons.shopping_basket_rounded),
            label: Text(l10n.shoppingListButton),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.generatingPlan),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: Text(l10n.regeneratePlanButton),
          ),
          if (planGenerationQuotaMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              planGenerationQuotaMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
            ),
          ],
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
    final l10n = AppLocalizations.of(context);

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
              l10n.loadPlanErrorTitle,
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
              label: Text(l10n.generatePlanButton),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retryButton),
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
    required this.isReplacing,
    required this.onConsumedChanged,
    required this.onReplaceMeal,
  });

  final Meal meal;
  final bool consumed;
  final bool isReplacing;
  final ValueChanged<bool> onConsumedChanged;
  final Future<void> Function() onReplaceMeal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      key: ValueKey('meal-card-${meal.id}'),
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.push(AppRoutes.mealDetailsFor(meal.id)),
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
                isReplacing
                    ? const SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        key: ValueKey('meal-replace-button-${meal.id}'),
                        tooltip: l10n.replaceMealTooltip,
                        onPressed: onReplaceMeal,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        color: AppColors.primary,
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

class _MacroRing extends StatelessWidget {
  const _MacroRing({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final int proteinPercent;
  final int carbsPercent;
  final int fatPercent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: CustomPaint(
        painter: _MacroRingPainter(
          proteinPercent: proteinPercent,
          carbsPercent: carbsPercent,
          fatPercent: fatPercent,
        ),
      ),
    );
  }
}

class _MacroRingPainter extends CustomPainter {
  _MacroRingPainter({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final int proteinPercent;
  final int carbsPercent;
  final int fatPercent;

  static const double _strokeWidth = 8;
  static const double _gapRadians = 0.12;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = proteinPercent + carbsPercent + fatPercent;
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..color = AppColors.surfaceVariant;
    canvas.drawCircle(center, radius, backgroundPaint);

    if (total <= 0) {
      return;
    }

    final segments = <(int, Color)>[
      (proteinPercent, AppColors.primary),
      (carbsPercent, AppColors.secondary),
      (fatPercent, AppColors.accent),
    ];

    var startAngle = -math.pi / 2; // Start at the top.
    for (final (value, color) in segments) {
      if (value <= 0) {
        continue;
      }

      final sweep = (value / total) * 2 * math.pi - _gapRadians;
      if (sweep <= 0) {
        continue;
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + _gapRadians;
    }
  }

  @override
  bool shouldRepaint(_MacroRingPainter oldDelegate) {
    return oldDelegate.proteinPercent != proteinPercent ||
        oldDelegate.carbsPercent != carbsPercent ||
        oldDelegate.fatPercent != fatPercent;
  }
}
