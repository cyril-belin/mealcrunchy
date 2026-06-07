import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/generating_plan_view_model.dart';
import 'package:provider/provider.dart';

class GeneratingPlanScreen extends StatefulWidget {
  const GeneratingPlanScreen({super.key});

  @override
  State<GeneratingPlanScreen> createState() => _GeneratingPlanScreenState();
}

class _GeneratingPlanScreenState extends State<GeneratingPlanScreen>
    with SingleTickerProviderStateMixin {
  bool _started = false;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    _progressController.animateTo(0.9, curve: Curves.easeOut);
    Future.microtask(context.read<GeneratingPlanViewModel>().generate);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GeneratingPlanViewModel>().state;
    if (state is ViewData<MealPlan>) {
      final router = GoRouter.of(context);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _progressController.animateTo(
          1,
          duration: const Duration(milliseconds: 400),
        );
        if (mounted) {
          router.go(AppRoutes.mealPlan);
        }
      });
    } else if (state is ViewError<MealPlan>) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _progressController.stop();
      });
    }

    return AppScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BrandMark(size: 64)),
          const SizedBox(height: 28),
          Icon(
            Icons.restaurant_rounded,
            size: 160,
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 24),
          Text(
            'Création de votre menu idéal...',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Analyse de vos préférences et objectifs nutritionnels',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 26),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, _) {
              final value = _progressController.value;
              final percent = (value * 100).round();
              final isError = state is ViewError<MealPlan>;
              final hint = switch (value) {
                _ when isError => 'Interrompu',
                >= 1.0 => 'Terminé',
                >= 0.85 => 'Presque fini',
                >= 0.4 => 'En cours',
                _ => 'Démarrage',
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProgressPill(progress: value),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percent % terminé',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        hint,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _GenerationStateCard(state: state),
          const SizedBox(height: 24),
          if (state case ViewError<MealPlan>())
            ElevatedButton.icon(
              onPressed: () {
                _progressController.value = 0;
                _progressController.animateTo(0.9, curve: Curves.easeOut);
                context.read<GeneratingPlanViewModel>().generate();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
        ],
      ),
    );
  }
}

class _GenerationStateCard extends StatelessWidget {
  const _GenerationStateCard({required this.state});

  final ViewState<MealPlan> state;

  @override
  Widget build(BuildContext context) {
    final isError = state is ViewError<MealPlan>;
    final title = isError ? 'Génération interrompue' : 'Personnalisation IA';
    final message = switch (state) {
      ViewError<MealPlan>(message: final message) => _cleanMessage(message),
      _ =>
        'Nous équilibrons vos macros pour garder votre énergie toute la journée.',
    };

    return SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isError ? AppColors.error : AppColors.accent).withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.auto_awesome_rounded,
              color: isError ? AppColors.error : AppColors.accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _cleanMessage(String message) {
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
