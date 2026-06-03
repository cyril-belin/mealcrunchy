import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/features/auth/views/login_sign_up_screen.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/daily_meal_plan_screen.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/meal_details_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/generating_plan_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_activity_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_allergies_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_goals_screen.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/onboarding_metrics_screen.dart';
import 'package:mealcrunchy/ui/features/profile/views/profile_preferences_screen.dart';
import 'package:mealcrunchy/ui/features/splash/views/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
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
        return MealDetailsScreen(mealId: state.pathParameters['mealId'] ?? '');
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePreferencesScreen(),
    ),
  ],
);
