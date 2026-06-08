import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:provider/provider.dart';

class OnboardingAllergiesScreen extends StatelessWidget {
  const OnboardingAllergiesScreen({super.key});

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
                onPressed: () => context.go(AppRoutes.onboardingGoals),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(child: ProgressPill(progress: 0.3)),
              TextButton(
                onPressed: () => context.go(AppRoutes.onboardingActivity),
                child: const Text('Passer'),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Des allergies ou aversions ?',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Nous les exclurons de vos plans repas',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 22),
          ...viewModel.allergies.map(
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
                onTap: () => viewModel.toggleAllergy(option.title),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Autres aversions',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: viewModel.customAversionsInput,
            onChanged: viewModel.updateCustomAversions,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'ex. coriandre, champignons...',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.onboardingActivity),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }
}
