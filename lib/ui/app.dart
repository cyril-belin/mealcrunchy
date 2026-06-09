import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/data/repositories/auth_repository.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/repositories/preferences_repository.dart';
import 'package:mealcrunchy/data/repositories/shopping_list_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/auth_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/data/services/observability_service.dart';
import 'package:mealcrunchy/l10n/app_localizations.dart';
import 'package:mealcrunchy/ui/core/routing/app_router.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_theme.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/generating_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';
import 'package:mealcrunchy/ui/features/shopping_list/view_models/shopping_list_view_model.dart';
import 'package:provider/provider.dart';

class MealCrunchyApp extends StatelessWidget {
  const MealCrunchyApp({
    super.key,
    this.authRepository,
    this.localDataStore,
    this.observabilityService,
    this.initialLocation = AppRoutes.splash,
  });

  final AuthRepository? authRepository;
  final LocalDataStore? localDataStore;
  final ObservabilityService? observabilityService;
  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ObservabilityService>(
          create: (_) =>
              observabilityService ?? const NoopObservabilityService(),
        ),
        Provider<AiProxyService>(create: (_) => AiProxyService()),
        Provider<AuthService>(create: (_) => FirebaseAuthService()),
        ProxyProvider<AuthService, AuthRepository>(
          update: (_, authService, previous) {
            return authRepository ??
                previous ??
                AuthRepository(service: authService);
          },
        ),
        Provider<LocalDataStore>(
          create: (_) => localDataStore ?? SharedPreferencesLocalDataStore(),
        ),
        ProxyProvider<LocalDataStore, ShoppingListRepository>(
          update: (_, localDataStore, _) {
            return ShoppingListRepository(localDataStore: localDataStore);
          },
        ),
        ProxyProvider3<
          AiProxyService,
          LocalDataStore,
          ShoppingListRepository,
          MealPlanRepository
        >(
          update:
              (_, aiProxyService, localDataStore, shoppingListRepository, _) {
                return MealPlanRepository(
                  aiProxyService: aiProxyService,
                  localDataStore: localDataStore,
                  shoppingListRepository: shoppingListRepository,
                );
              },
        ),
        ProxyProvider<LocalDataStore, PreferencesRepository>(
          update: (_, localDataStore, _) {
            return PreferencesRepository(localDataStore: localDataStore);
          },
        ),
        ChangeNotifierProxyProvider2<
          AuthRepository,
          LocalDataStore,
          AuthViewModel
        >(
          create: (context) {
            return AuthViewModel(
              authRepository: context.read<AuthRepository>(),
              localDataStore: context.read<LocalDataStore>(),
            );
          },
          update: (_, repository, localDataStore, previous) {
            return previous ??
                AuthViewModel(
                  authRepository: repository,
                  localDataStore: localDataStore,
                );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return OnboardingViewModel(
              localDataStore: context.read<LocalDataStore>(),
            );
          },
        ),
        ChangeNotifierProxyProvider3<
          MealPlanRepository,
          LocalDataStore,
          ObservabilityService,
          GeneratingPlanViewModel
        >(
          create: (context) {
            return GeneratingPlanViewModel(
              mealPlanRepository: context.read<MealPlanRepository>(),
              localDataStore: context.read<LocalDataStore>(),
              observabilityService: context.read<ObservabilityService>(),
            );
          },
          update:
              (_, repository, localDataStore, observabilityService, previous) {
                return previous ??
                    GeneratingPlanViewModel(
                      mealPlanRepository: repository,
                      localDataStore: localDataStore,
                      observabilityService: observabilityService,
                    );
              },
        ),
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
        ChangeNotifierProxyProvider<
          ShoppingListRepository,
          ShoppingListViewModel
        >(
          create: (context) {
            return ShoppingListViewModel(
              shoppingListRepository: context.read<ShoppingListRepository>(),
            );
          },
          update: (_, repository, previous) {
            return previous ??
                ShoppingListViewModel(shoppingListRepository: repository);
          },
        ),
      ],
      child: _MealCrunchyRouter(initialLocation: initialLocation),
    );
  }
}

class _MealCrunchyRouter extends StatefulWidget {
  const _MealCrunchyRouter({required this.initialLocation});

  final String initialLocation;

  @override
  State<_MealCrunchyRouter> createState() => _MealCrunchyRouterState();
}

class _MealCrunchyRouterState extends State<_MealCrunchyRouter> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final navigatorObserver = context
        .read<ObservabilityService>()
        .createNavigatorObserver();
    _router ??= createAppRouter(
      authViewModel: context.read<AuthViewModel>(),
      initialLocation: widget.initialLocation,
      observers: [?navigatorObserver],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MealCrunchy',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router!,
      debugShowCheckedModeBanner: false,
    );
  }
}
