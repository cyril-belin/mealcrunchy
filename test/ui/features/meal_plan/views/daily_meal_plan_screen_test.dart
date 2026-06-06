import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/daily_meal_plan_screen.dart';
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

class _DashboardMealPlanRepository extends MealPlanRepository {
  _DashboardMealPlanRepository()
    : super(
        contentService: const StaticDesignContentService(),
        trackingStore: MemoryDailyMealTrackingStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_breakfast];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}
