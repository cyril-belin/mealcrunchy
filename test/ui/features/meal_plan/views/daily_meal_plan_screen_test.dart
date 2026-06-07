import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/theme/app_theme.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/daily_meal_plan_screen.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/meal_details_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('meal checkbox is visible and updates calorie progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      _DashboardTestApp(
        viewModel: MealPlanViewModel(
          mealPlanRepository: _DashboardMealPlanRepository(),
          now: () => DateTime(2026, 6, 6),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aujourd\'hui, 6 juin'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('meal-consumed-checkbox-breakfast')),
      findsOneWidget,
    );
    expect(find.text('0 / 2000 kcal'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('meal-consumed-checkbox-breakfast')),
    );
    await tester.pumpAndSettle();

    expect(find.text('400 / 2000 kcal'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);
  });

  testWidgets('dashboard and detail show the same meal values', (tester) async {
    await tester.pumpWidget(
      _DashboardRouterTestApp(
        viewModel: MealPlanViewModel(
          mealPlanRepository: _CoherenceMealPlanRepository(),
          now: () => DateTime(2026, 6, 6),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Petit-déjeuner'), findsOneWidget);
    expect(find.text('731 kcal  -  P 43g  G 82g  L 19g'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('meal-card-coherence-breakfast')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Petit-déjeuner'), findsOneWidget);
    expect(find.text('Repas coherence'), findsOneWidget);
    expect(find.text('731 kcal'), findsOneWidget);
    expect(find.text('43g'), findsOneWidget);
    expect(find.text('82g'), findsOneWidget);
    expect(find.text('19g'), findsOneWidget);
  });

  testWidgets('regenerate button navigates to the generation screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _DashboardRouterTestApp(
        viewModel: MealPlanViewModel(
          mealPlanRepository: _DashboardMealPlanRepository(),
          now: () => DateTime(2026, 6, 6),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Regenerer le plan IA'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Regenerer le plan IA'));
    await tester.pumpAndSettle();

    expect(find.text('Generation reached'), findsOneWidget);
  });
}

class _DashboardTestApp extends StatelessWidget {
  const _DashboardTestApp({required this.viewModel});

  final MealPlanViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealPlanViewModel>.value(
      value: viewModel,
      child: const MaterialApp(home: DailyMealPlanScreen()),
    );
  }
}

class _DashboardRouterTestApp extends StatelessWidget {
  const _DashboardRouterTestApp({required this.viewModel});

  final MealPlanViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: AppRoutes.mealPlan,
      routes: [
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
          path: AppRoutes.generatingPlan,
          builder: (context, state) =>
              const Material(child: Center(child: Text('Generation reached'))),
        ),
      ],
    );

    return ChangeNotifierProvider<MealPlanViewModel>.value(
      value: viewModel,
      child: MaterialApp.router(
        title: 'MealCrunchy',
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }
}

const _breakfast = Meal(
  id: 'breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Breakfast',
  calories: 400,
  protein: 30,
  carbs: 35,
  fat: 12,
  imagePrompt: 'breakfast',
  duration: '10 min',
  ingredients: ['Ingredient'],
  instructions: ['Instruction'],
);

const _targetSummary = NutritionSummary(
  consumedCalories: 1850,
  targetCalories: 2000,
  progress: 0.92,
  proteinPercent: 30,
  carbsPercent: 45,
  fatPercent: 25,
);

const _coherenceBreakfast = Meal(
  id: 'coherence-breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Repas coherence',
  calories: 731,
  protein: 43,
  carbs: 82,
  fat: 19,
  imagePrompt: 'coherence',
  duration: '42 min',
  ingredients: ['Ingredient coherence'],
  instructions: ['Instruction coherence'],
);

class _DashboardMealPlanRepository extends MealPlanRepository {
  _DashboardMealPlanRepository()
    : super(trackingStore: MemoryDailyMealTrackingStore());

  @override
  Future<List<Meal>> getDailyMeals() async => const [_breakfast];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _CoherenceMealPlanRepository extends MealPlanRepository {
  _CoherenceMealPlanRepository()
    : super(trackingStore: MemoryDailyMealTrackingStore());

  @override
  Future<List<Meal>> getDailyMeals() async => const [_coherenceBreakfast];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}
