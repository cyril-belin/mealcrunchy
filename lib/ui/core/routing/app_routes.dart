class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const auth = '/auth';
  static const onboardingGoals = '/onboarding/goals';
  static const onboardingAllergies = '/onboarding/allergies';
  static const onboardingActivity = '/onboarding/activity';
  static const onboardingMetrics = '/onboarding/metrics';
  static const generatingPlan = '/generating-plan';
  static const mealPlan = '/meal-plan';
  static const mealDetails = '/meal-plan/:mealId';
  static const profile = '/profile';

  static String mealDetailsFor(String mealId) => '/meal-plan/$mealId';
}
