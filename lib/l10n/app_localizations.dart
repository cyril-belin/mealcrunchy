import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Dashboard label for the current day.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui, {date}'**
  String todayDateLabel(String date);

  /// Dashboard title for the generated AI meal plan.
  ///
  /// In fr, this message translates to:
  /// **'Votre plan IA'**
  String get mealPlanTitle;

  /// Title of the daily calorie objective card.
  ///
  /// In fr, this message translates to:
  /// **'Objectif quotidien'**
  String get dailyGoalTitle;

  /// Section title for the meals scheduled for the day.
  ///
  /// In fr, this message translates to:
  /// **'Repas prévus'**
  String get plannedMealsTitle;

  /// Small label indicating meals are optimized by AI.
  ///
  /// In fr, this message translates to:
  /// **'Optimisé par IA'**
  String get aiOptimizedLabel;

  /// SnackBar shown when saving meal tracking fails.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer le suivi. Réessayez.'**
  String get trackingSaveError;

  /// SnackBar shown after a meal replacement succeeds without quota information.
  ///
  /// In fr, this message translates to:
  /// **'Repas remplacé.'**
  String get mealReplaced;

  /// Tooltip for the AI meal replacement button.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer'**
  String get replaceMealTooltip;

  /// Title of the protein/carbs/fat distribution card.
  ///
  /// In fr, this message translates to:
  /// **'Répartition des macros'**
  String get macroDistributionTitle;

  /// Summary of macro nutrient percentages.
  ///
  /// In fr, this message translates to:
  /// **'Protéines {proteinPercent}% - Glucides {carbsPercent}% - Lipides {fatPercent}%'**
  String macroDistributionSummary(
    int proteinPercent,
    int carbsPercent,
    int fatPercent,
  );

  /// Button opening the shopping list screen.
  ///
  /// In fr, this message translates to:
  /// **'Voir la liste de courses'**
  String get shoppingListButton;

  /// Button starting AI meal plan regeneration.
  ///
  /// In fr, this message translates to:
  /// **'Régénérer le plan IA'**
  String get regeneratePlanButton;

  /// Title shown when the meal plan dashboard cannot load.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le plan.'**
  String get loadPlanErrorTitle;

  /// Button starting plan generation from an empty/error state.
  ///
  /// In fr, this message translates to:
  /// **'Générer un plan'**
  String get generatePlanButton;

  /// Generic retry button label.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryButton;

  /// Monthly AI plan regeneration quota remaining.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Il vous reste 0 régénération ce mois-ci.} =1{Il vous reste 1 régénération ce mois-ci.} other{Il vous reste {count} régénérations ce mois-ci.}}'**
  String remainingRegenerations(int count);

  /// Monthly AI meal replacement quota remaining.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Il vous reste 0 remplacement ce mois-ci.} =1{Il vous reste 1 remplacement ce mois-ci.} other{Il vous reste {count} remplacements ce mois-ci.}}'**
  String remainingReplacements(int count);

  /// SnackBar shown after a meal replacement succeeds with quota information.
  ///
  /// In fr, this message translates to:
  /// **'Repas remplacé. {quotaMessage}'**
  String mealReplacedWithQuota(String quotaMessage);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
