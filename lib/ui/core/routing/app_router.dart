import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/auth/views/login_sign_up_screen.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/daily_meal_plan_screen.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/meal_details_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/generating_plan_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_activity_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_allergies_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_goals_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_metrics_screen.dart';
import 'package:mealcrunchy/ui/features/profile/views/profile_preferences_screen.dart';
import 'package:mealcrunchy/ui/features/shopping_list/views/shopping_list_screen.dart';
import 'package:mealcrunchy/ui/features/splash/views/splash_screen.dart';

GoRouter createAppRouter({
  required AuthViewModel authViewModel,
  String initialLocation = AppRoutes.splash,
  List<NavigatorObserver> observers = const <NavigatorObserver>[],
}) {
  return GoRouter(
    initialLocation: initialLocation,
    observers: observers,
    refreshListenable: authViewModel,
    redirect: (context, state) {
      final location = state.uri.path;
      final isAuthRoute = location == AppRoutes.auth;
      final isSplashRoute = location == AppRoutes.splash;

      if (authViewModel.isLoading) {
        return null;
      }

      if (isSplashRoute || isAuthRoute) {
        if (authViewModel.isAuthenticated) {
          return authViewModel.hasActiveMealPlan
              ? AppRoutes.mealPlan
              : AppRoutes.onboardingGoals;
        }
        return null;
      }

      if (!authViewModel.isAuthenticated) {
        return AppRoutes.auth;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const LoginSignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingGoals,
        builder: (context, state) => const OnboardingGoalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingAllergies,
        builder: (context, state) => const OnboardingAllergiesScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingActivity,
        builder: (context, state) => const OnboardingActivityScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingMetrics,
        builder: (context, state) => const OnboardingMetricsScreen(),
      ),
      GoRoute(
        path: AppRoutes.generatingPlan,
        builder: (context, state) => const GeneratingPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.mealPlan,
        builder: (context, state) => const DailyMealPlanScreen(),
      ),
      GoRoute(
        path: AppRoutes.mealDetails,
        builder: (context, state) {
          return MealDetailsScreen(
            mealId: state.pathParameters['mealId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.shoppingList,
        builder: (context, state) => const ShoppingListScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePreferencesScreen(),
      ),
    ],
  );
}
