import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:provider/provider.dart';

class OnboardingMetricsScreen extends StatelessWidget {
  const OnboardingMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final validationMessage = viewModel.shouldShowProfileValidationMessage
        ? viewModel.profileValidationMessage
        : null;

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.onboardingActivity),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const Expanded(child: ProgressPill(progress: 0.7)),
              const SizedBox(width: 12),
              Text('7 sur 10', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Vos mesures',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Cela aide l\'IA à calculer vos besoins caloriques précis.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          _MetricField(
            fieldKey: const ValueKey('onboarding-age-field'),
            label: 'Age',
            hint: 'ex. 28',
            suffix: 'ans',
            initialValue: viewModel.ageInput,
            onChanged: viewModel.updateAge,
          ),
          const SizedBox(height: 14),
          _MetricField(
            fieldKey: const ValueKey('onboarding-height-field'),
            label: 'Taille',
            hint: 'ex. 175',
            suffix: 'cm',
            initialValue: viewModel.heightCmInput,
            onChanged: viewModel.updateHeightCm,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricField(
                  fieldKey: ValueKey('onboarding-current-weight-field'),
                  label: 'Poids actuel',
                  hint: '75',
                  suffix: 'kg',
                  initialValue: viewModel.currentWeightKgInput,
                  onChanged: viewModel.updateCurrentWeightKg,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricField(
                  fieldKey: ValueKey('onboarding-target-weight-field'),
                  label: 'Poids cible',
                  hint: '70',
                  suffix: 'kg',
                  initialValue: viewModel.targetWeightKgInput,
                  onChanged: viewModel.updateTargetWeightKg,
                ),
              ),
            ],
          ),
          if (validationMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              validationMessage,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 18),
          SoftCard(
            color: AppColors.info.withValues(alpha: 0.08),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_rounded, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Nous utilisons l\'équation de Mifflin-St Jeor pour estimer votre métabolisme de base.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.monitor_weight_rounded,
            size: 130,
            color: AppColors.primary.withValues(alpha: 0.22),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            key: const ValueKey('onboarding-metrics-continue'),
            onPressed: () async {
              final shouldReturnToProfile = viewModel.isEditingProfile;
              final profile = await viewModel.submitProfile();
              if (profile == null) {
                return;
              }

              if (!context.mounted) {
                return;
              }

              context.go(
                shouldReturnToProfile
                    ? AppRoutes.profile
                    : AppRoutes.generatingPlan,
              );
            },
            child: const Text('Continuer'),
          ),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.onboardingActivity),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.initialValue,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final String suffix;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
      ),
    );
  }
}
