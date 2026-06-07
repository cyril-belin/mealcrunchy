import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:provider/provider.dart';

class OnboardingGoalsScreen extends StatelessWidget {
  const OnboardingGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _OnboardingTopBar(stepLabel: 'Étape 2 sur 10', progress: 0.2),
          const SizedBox(height: 28),
          Text(
            'Quel est votre objectif ?',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez l\'objectif santé principal que vous voulez atteindre avec MealCrunchy.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 22),
          ...viewModel.goals.map(
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
                onTap: () => viewModel.selectGoal(option.title),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preference alimentaire',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Suivez-vous un style alimentaire particulier ?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                ChoiceChipGrid(
                  items: viewModel.dietStyles
                      .map(
                        (option) => (
                          title: option.title,
                          iconName: option.iconName,
                          selected: option.selected,
                        ),
                      )
                      .toList(),
                  onSelected: viewModel.selectDietStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.onboardingAllergies),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.mealPlan),
            child: const Text('Je configurerai cela plus tard'),
          ),
        ],
      ),
    );
  }
}

class _OnboardingTopBar extends StatelessWidget {
  const _OnboardingTopBar({required this.stepLabel, required this.progress});

  final String stepLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48),
        Expanded(child: ProgressPill(progress: progress)),
        const SizedBox(width: 12),
        Text(stepLabel, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
