import 'package:flutter/material.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/ui/core/routing/app_router.dart';
import 'package:mealcrunchy/ui/core/theme/app_theme.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class MealCrunchyApp extends StatelessWidget {
  const MealCrunchyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => const StaticDesignContentService()),
        ProxyProvider<StaticDesignContentService, MealPlanRepository>(
          update: (_, contentService, previous) {
            return MealPlanRepository(contentService: contentService);
          },
        ),
        ProxyProvider<StaticDesignContentService, PreferencesRepository>(
          update: (_, contentService, previous) {
            return PreferencesRepository(contentService: contentService);
          },
        ),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProxyProvider<MealPlanRepository, MealPlanViewModel>(
          create: (context) {
            return MealPlanViewModel(
              mealPlanRepository: context.read<MealPlanRepository>(),
            );
          },
          update: (_, repository, previous) {
            return previous ??
                MealPlanViewModel(mealPlanRepository: repository);
          },
        ),
        ChangeNotifierProxyProvider<PreferencesRepository, ProfileViewModel>(
          create: (context) {
            return ProfileViewModel(
              preferencesRepository: context.read<PreferencesRepository>(),
            );
          },
          update: (_, repository, previous) {
            return previous ??
                ProfileViewModel(preferencesRepository: repository);
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'MealCrunchy',
        theme: AppTheme.light(),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
