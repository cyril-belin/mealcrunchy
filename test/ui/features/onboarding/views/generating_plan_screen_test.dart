import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/activity_level.dart';
import 'package:mealcrunchy/domain/models/diet_style.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_goal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/generating_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/views/generating_plan_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('generates the plan and navigates to the dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(repository: _WidgetMealPlanRepository(), profile: _profile),
    );

    expect(find.text('Création de votre menu idéal...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Meal plan reached'), findsOneWidget);
  });

  testWidgets('shows an error and retries generation', (tester) async {
    final repository = _WidgetMealPlanRepository(failuresRemaining: 1);
    await tester.pumpWidget(_app(repository: repository, profile: _profile));
    await tester.pumpAndSettle();

    expect(find.text('Generation impossible'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Réessayer'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(repository.generateCount, 2);
    expect(find.text('Meal plan reached'), findsOneWidget);
  });
}

Widget _app({
  required _WidgetMealPlanRepository repository,
  required UserProfile profile,
}) {
  final localDataStore = _WidgetLocalDataStore(userProfile: profile);
  final router = GoRouter(
    initialLocation: AppRoutes.generatingPlan,
    routes: [
      GoRoute(
        path: AppRoutes.generatingPlan,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => GeneratingPlanViewModel(
            mealPlanRepository: repository,
            localDataStore: localDataStore,
          ),
          child: const GeneratingPlanScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.mealPlan,
        builder: (context, state) =>
            const Material(child: Center(child: Text('Meal plan reached'))),
      ),
    ],
  );

  return MaterialApp.router(routerConfig: router);
}

const _profile = UserProfile(
  goal: NutritionGoal.loseWeight,
  dietStyle: DietStyle.mediterranean,
  allergies: ['Cacahuetes'],
  customAversions: ['Olives'],
  activityLevel: ActivityLevel.moderatelyActive,
  mealTiming: ['3 repas classiques'],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
);

final _plan = MealPlan(
  generatedAt: DateTime.utc(2026, 6, 7),
  days: List.generate(
    7,
    (index) => MealPlanDay(
      id: 'day-${index + 1}',
      label: 'Jour ${index + 1}',
      meals: const [_meal],
    ),
  ),
  summary: const NutritionSummary(
    consumedCalories: 0,
    targetCalories: 2100,
    progress: 0,
    proteinPercent: 32,
    carbsPercent: 43,
    fatPercent: 25,
  ),
);

const _meal = Meal(
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

class _WidgetMealPlanRepository extends MealPlanRepository {
  _WidgetMealPlanRepository({this.failuresRemaining = 0})
    : super(
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _WidgetLocalDataStore(userProfile: _profile),
      );

  int failuresRemaining;
  int generateCount = 0;

  @override
  Future<MealPlan> generateActiveMealPlan(UserProfile profile) async {
    generateCount += 1;
    if (failuresRemaining > 0) {
      failuresRemaining -= 1;
      throw Exception('Generation impossible');
    }
    return _plan;
  }
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

class _WidgetLocalDataStore implements LocalDataStore {
  _WidgetLocalDataStore({required this.userProfile});

  final UserProfile userProfile;

  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async {
    return const <ShoppingListItem>[];
  }

  @override
  Future<UserProfile?> loadUserProfile() async => userProfile;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}
}
