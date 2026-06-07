import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:provider/provider.dart';

class OnboardingActivityScreen extends StatelessWidget {
  const OnboardingActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.onboardingAllergies),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const Expanded(child: ProgressPill(progress: 0.62)),
              const SizedBox(width: 12),
              Text(
                'Étape 5 sur 8',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Quel est votre niveau d\'activité ?',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Cela nous aide à calculer précisément vos besoins caloriques quotidiens.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 22),
          ...viewModel.activityLevels.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OptionCard(
                key: ValueKey(
                  'option-${option.title}-${option.selected ? 'selected' : 'unselected'}',
                ),
                title: option.title,
                subtitle: option.subtitle,
                iconName: option.iconName,
                selected: option.selected,
                onTap: () => viewModel.selectActivityLevel(option.title),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Horaires de repas préférés',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Quand aimez-vous manger habituellement ? Sélectionnez tout ce qui convient.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 14),
          ChoiceChipGrid(
            items: viewModel.mealTiming
                .map(
                  (option) => (
                    title: option.title,
                    iconName: option.iconName,
                    selected: option.selected,
                  ),
                )
                .toList(),
            onSelected: viewModel.toggleMealTiming,
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.onboardingMetrics),
            child: const Text('Continuer vers les préférences'),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.mealPlan),
            child: const Text('Je le ferai plus tard'),
          ),
        ],
      ),
    );
  }
}
