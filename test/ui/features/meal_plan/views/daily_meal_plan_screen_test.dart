import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
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

  testWidgets('replace action updates one meal from the dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      _DashboardTestApp(
        viewModel: MealPlanViewModel(
          mealPlanRepository: _ReplacingDashboardMealPlanRepository(),
          now: () => DateTime(2026, 6, 6),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Breakfast'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('meal-replace-button-breakfast')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Breakfast remplace'), findsOneWidget);
    expect(find.text('Repas remplacé.'), findsOneWidget);
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
      find.text('Régénérer le plan IA'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Régénérer le plan IA'));
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

const _replacementBreakfast = Meal(
  id: 'breakfast',
  type: 'PETIT-DEJEUNER',
  name: 'Breakfast remplace',
  calories: 500,
  protein: 38,
  carbs: 42,
  fat: 16,
  imagePrompt: 'replacement breakfast',
  duration: '12 min',
  ingredients: ['Ingredient remplace'],
  instructions: ['Instruction remplace'],
);

final _replacementPlan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 6),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: index == 0 ? const [_replacementBreakfast] : const [_breakfast],
    ),
  ),
  summary: _targetSummary,
);

class _DashboardMealPlanRepository extends MealPlanRepository {
  _DashboardMealPlanRepository()
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _MemoryLocalDataStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_breakfast];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _CoherenceMealPlanRepository extends MealPlanRepository {
  _CoherenceMealPlanRepository()
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _MemoryLocalDataStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_coherenceBreakfast];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _ReplacingDashboardMealPlanRepository
    extends _DashboardMealPlanRepository {
  @override
  Future<MealPlan> replaceMeal(String mealId) async => _replacementPlan;
}

class _UnusedAiProxyService extends AiProxyService {
  _UnusedAiProxyService() : super(client: _UnusedAiCallableClient());
}

class _UnusedAiCallableClient implements AiCallableClient {
  @override
  Future<Object?> call(String name, Map<String, Object?> data) {
    throw UnimplementedError();
  }
}

class _MemoryLocalDataStore implements LocalDataStore {
  final Map<String, Set<String>> _consumed = {};

  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async =>
      _consumed[dayKey]?.toSet() ?? <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async =>
      const <ShoppingListItem>[];

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {
    _consumed[dayKey] = ids.toSet();
  }

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}
}
