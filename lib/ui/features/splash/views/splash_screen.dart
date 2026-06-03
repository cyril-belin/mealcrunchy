import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: -110,
            top: -40,
            child: _Glow(
              size: 300,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            right: -150,
            bottom: -80,
            child: _Glow(
              size: 400,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BrandMark(size: 120),
                  const SizedBox(height: 28),
                  Text(
                    'MealCrunchy',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Votre guide nutritionnel propulse par l\'IA',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 120,
                    color: AppColors.primary.withValues(alpha: 0.22),
                  ),
                  const SizedBox(height: 24),
                  const ProgressPill(progress: 0.44),
                  const SizedBox(height: 10),
                  Text(
                    'Personnalisation de votre experience...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.auth),
                    child: const Text('Commencer'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
