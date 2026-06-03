import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';

class OnboardingMetricsScreen extends StatelessWidget {
  const OnboardingMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Cela aide l\'IA a calculer vos besoins caloriques precis.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          const _MetricField(label: 'Age', hint: 'ex. 28', suffix: 'ans'),
          const SizedBox(height: 14),
          const _MetricField(label: 'Taille', hint: 'ex. 175', suffix: 'cm'),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _MetricField(
                  label: 'Poids actuel',
                  hint: '75',
                  suffix: 'kg',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MetricField(
                  label: 'Poids cible',
                  hint: '70',
                  suffix: 'kg',
                ),
              ),
            ],
          ),
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
                    'Nous utilisons l\'equation de Mifflin-St Jeor pour estimer votre metabolisme de base.',
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
            onPressed: () => context.go(AppRoutes.generatingPlan),
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
    required this.label,
    required this.hint,
    required this.suffix,
  });

  final String label;
  final String hint;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
      ),
    );
  }
}
