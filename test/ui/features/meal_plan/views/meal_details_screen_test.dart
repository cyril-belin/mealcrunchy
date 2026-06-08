import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealcrunchy/data/repositories/meal_plan_repository.dart';
import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/data/services/local_data_store.dart';
import 'package:mealcrunchy/domain/models/meal.dart';
import 'package:mealcrunchy/domain/models/meal_plan.dart';
import 'package:mealcrunchy/domain/models/nutrition_summary.dart';
import 'package:mealcrunchy/domain/models/shopping_list_item.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';
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

  testWidgets('shows an error when meal replacement fails', (tester) async {
    await tester.pumpWidget(
      _MealDetailsTestApp(
        mealId: _dinner.id,
        repository: _ThrowingDetailsMealPlanRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Remplacer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Remplacer'));
    await tester.pumpAndSettle();

    expect(find.text('Alternative IA indisponible.'), findsOneWidget);
  });

  testWidgets(
    'shows the quota error when meal replacement quota is exhausted',
    (tester) async {
      await tester.pumpWidget(
        _MealDetailsTestApp(
          mealId: _dinner.id,
          repository: _ThrowingDetailsMealPlanRepository(
            message: 'Quota IA temporairement atteint.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Remplacer'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Remplacer'));
      await tester.pumpAndSettle();

      expect(find.text('Quota IA temporairement atteint.'), findsOneWidget);
    },
  );
}

class _MealDetailsTestApp extends StatelessWidget {
  const _MealDetailsTestApp({required this.mealId, this.repository});

  final String mealId;
  final MealPlanRepository? repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealPlanViewModel>(
      create: (_) => MealPlanViewModel(
        mealPlanRepository: repository ?? _DetailsMealPlanRepository(),
      ),
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
        aiProxyService: _UnusedAiProxyService(),
        localDataStore: _NoOpLocalDataStore(),
      );

  @override
  Future<List<Meal>> getDailyMeals() async => const [_dinner];

  @override
  Future<NutritionSummary> getNutritionSummary() async => _targetSummary;
}

class _ThrowingDetailsMealPlanRepository extends _DetailsMealPlanRepository {
  _ThrowingDetailsMealPlanRepository({
    this.message = 'Alternative IA indisponible.',
  });

  final String message;

  @override
  Future<MealPlan> replaceMeal(String mealId, {Meal? currentMeal}) async {
    throw MealPlanReplacementException(message);
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

class _NoOpLocalDataStore implements LocalDataStore {
  @override
  Future<MealPlan?> loadActiveMealPlan() async => null;

  @override
  Future<Set<String>> loadConsumedMealIds(String dayKey) async => <String>{};

  @override
  Future<List<ShoppingListItem>> loadShoppingList() async =>
      const <ShoppingListItem>[];

  @override
  Future<UserProfile?> loadUserProfile() async => null;

  @override
  Future<bool> loadProfileNeedsPlanRegeneration() async => false;

  @override
  Future<void> saveActiveMealPlan(MealPlan plan) async {}

  @override
  Future<void> saveConsumedMealIds(String dayKey, Set<String> ids) async {}

  @override
  Future<void> saveShoppingList(List<ShoppingListItem> items) async {}

  @override
  Future<void> saveUserProfile(UserProfile profile) async {}

  @override
  Future<void> saveProfileNeedsPlanRegeneration(bool value) async {}
}
