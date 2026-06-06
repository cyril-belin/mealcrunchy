import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/daily_meal_tracking_store.dart';
import 'package:mealcrunchy/data/services/static_design_content_service.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/ui/core/theme/app_theme.dart';
import 'package:mealcrunchy/ui/features/meal_plan/view_models/meal_plan_view_model.dart';
import 'package:mealcrunchy/ui/features/meal_plan/views/meal_details_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('renders exact meal values for cooking', (tester) async {
    await tester.pumpWidget(_MealDetailsTestApp(mealId: _dinner.id));
    await tester.pumpAndSettle();

    expect(find.text('Diner test fiable'), findsOneWidget);
    expect(find.text('Dîner'), findsOneWidget);
    expect(find.text('42 min'), findsOneWidget);
    expect(find.text('731 kcal'), findsOneWidget);
    expect(find.text('43g'), findsOneWidget);
    expect(find.text('82g'), findsOneWidget);
    expect(find.text('19g'), findsOneWidget);
    expect(find.text('Riz complet'), findsOneWidget);
    expect(find.text('Poulet grille'), findsOneWidget);
    expect(find.text('Cuire le riz complet.'), findsOneWidget);
    expect(find.text('Ajouter le poulet grille.'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
    expect(find.text('Marquer comme mange'), findsNothing);
  });

  testWidgets('renders a not found state for an unknown meal id', (
    tester,
  ) async {
    await tester.pumpWidget(const _MealDetailsTestApp(mealId: 'missing-meal'));
    await tester.pumpAndSettle();

    expect(find.text('Repas introuvable.'), findsOneWidget);
    expect(
      find.text('Ce repas n\'existe pas dans le plan actuel.'),
      findsOneWidget,
    );
    expect(find.text('Retour au plan'), findsOneWidget);
  });
}

class _MealDetailsTestApp extends StatelessWidget {
  const _MealDetailsTestApp({required this.mealId});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealPlanViewModel>(
      create: (_) =>
          MealPlanViewModel(mealPlanRepository: _DetailsMealPlanRepository()),
      child: MaterialApp(
        title: 'MealCrunchy',
        theme: AppTheme.light(),
        home: MealDetailsScreen(mealId: mealId),
      ),
    );
  }
}

const _dinner = Meal(
  id: 'dinner',
  type: 'DINER',
  name: 'Diner test fiable',
  calories: 731,
  protein: 43,
  carbs: 82,
  fat: 19,
  imagePrompt: 'dinner',
  duration: '42 min',
  ingredients: ['Riz complet', 'Poulet grille'],
  instructions: ['Cuire le riz complet.', 'Ajouter le poulet grille.'],
);

const _targetSummary = NutritionSummary(
  consumedCalories: 0,
  targetCalories: 2200,
  progress: 0,
  proteinPercent: 0,
  carbsPercent: 0,
  fatPercent: 0,
);

class _DetailsMealPlanRepository extends MealPlanRepository {
  _DetailsMealPlanRepository()
    : super(
        contentService: const StaticDesignContentService(),
        trackingStore: MemoryDailyMealTrackingStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_dinner];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}
