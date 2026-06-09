// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String todayDateLabel(String date) {
    return 'Aujourd\'hui, $date';
  }

  @override
  String get mealPlanTitle => 'Votre plan IA';

  @override
  String get dailyGoalTitle => 'Objectif quotidien';

  @override
  String get plannedMealsTitle => 'Repas prévus';

  @override
  String get aiOptimizedLabel => 'Optimisé par IA';

  @override
  String get trackingSaveError =>
      'Impossible d\'enregistrer le suivi. Réessayez.';

  @override
  String get mealReplaced => 'Repas remplacé.';

  @override
  String get replaceMealTooltip => 'Remplacer';

  @override
  String get macroDistributionTitle => 'Répartition des macros';

  @override
  String macroDistributionSummary(
    int proteinPercent,
    int carbsPercent,
    int fatPercent,
  ) {
    return 'Protéines $proteinPercent% - Glucides $carbsPercent% - Lipides $fatPercent%';
  }

  @override
  String get shoppingListButton => 'Voir la liste de courses';

  @override
  String get regeneratePlanButton => 'Régénérer le plan IA';

  @override
  String get loadPlanErrorTitle => 'Impossible de charger le plan.';

  @override
  String get generatePlanButton => 'Générer un plan';

  @override
  String get retryButton => 'Réessayer';

  @override
  String remainingRegenerations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il vous reste $count régénérations ce mois-ci.',
      one: 'Il vous reste 1 régénération ce mois-ci.',
      zero: 'Il vous reste 0 régénération ce mois-ci.',
    );
    return '$_temp0';
  }

  @override
  String remainingReplacements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il vous reste $count remplacements ce mois-ci.',
      one: 'Il vous reste 1 remplacement ce mois-ci.',
      zero: 'Il vous reste 0 remplacement ce mois-ci.',
    );
    return '$_temp0';
  }

  @override
  String mealReplacedWithQuota(String quotaMessage) {
    return 'Repas remplacé. $quotaMessage';
  }
}
