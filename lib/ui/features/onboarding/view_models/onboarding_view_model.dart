import 'package:flutter/foundation.dart';
import 'package:mealcrunchy/domain/models/onboarding_option.dart';
import 'package:mealcrunchy/domain/models/user_profile.dart';

class OnboardingViewModel extends ChangeNotifier {
  final List<OnboardingOption> _goals = [
    const OnboardingOption(
      title: 'Perdre du poids',
      subtitle: 'Bruler les graisses avec des plans caloriques maitrises',
      iconName: 'fitness',
      selected: true,
    ),
    const OnboardingOption(
      title: 'Manger plus sainement',
      subtitle: 'Ameliorer votre nutrition et vos habitudes alimentaires',
      iconName: 'restaurant',
    ),
    const OnboardingOption(
      title: 'Prendre du muscle',
      subtitle: 'Des repas riches en proteines pour la force et la masse',
      iconName: 'bolt',
    ),
    const OnboardingOption(
      title: 'Maintenir',
      subtitle: 'Garder votre poids actuel avec des repas equilibres',
      iconName: 'self_improvement',
    ),
  ];

  final List<OnboardingOption> _dietStyles = [
    const OnboardingOption(title: 'Vegan', subtitle: '', iconName: 'eco'),
    const OnboardingOption(
      title: 'Keto',
      subtitle: '',
      iconName: 'set_meal',
      selected: true,
    ),
    const OnboardingOption(title: 'Vegetarien', subtitle: '', iconName: 'egg'),
    const OnboardingOption(title: 'Paleo', subtitle: '', iconName: 'grain'),
    const OnboardingOption(
      title: 'Sans gluten',
      subtitle: '',
      iconName: 'bakery',
    ),
    const OnboardingOption(
      title: 'Mediterraneen',
      subtitle: '',
      iconName: 'public',
    ),
  ];

  final List<OnboardingOption> _allergies = [
    const OnboardingOption(
      title: 'Produits laitiers',
      subtitle: 'Lait, fromage, yaourt',
      iconName: 'ice_cream',
      selected: true,
    ),
    const OnboardingOption(
      title: 'Cacahuetes',
      subtitle: 'Beurre de cacahuete, huiles',
      iconName: 'nutrition',
    ),
    const OnboardingOption(
      title: 'Gluten',
      subtitle: 'Ble, seigle, orge',
      iconName: 'grain',
    ),
    const OnboardingOption(
      title: 'Fruits de mer',
      subtitle: 'Poisson et crustaces',
      iconName: 'set_meal',
    ),
    const OnboardingOption(
      title: 'Oeufs',
      subtitle: 'Oeufs entiers, mayonnaise',
      iconName: 'egg',
    ),
    const OnboardingOption(
      title: 'Soja',
      subtitle: 'Tofu, sauce soja',
      iconName: 'eco',
    ),
  ];

  final List<OnboardingOption> _activityLevels = [
    const OnboardingOption(
      title: 'Sedentaire',
      subtitle: 'Peu ou pas d\'exercice, travail de bureau',
      iconName: 'desk',
    ),
    const OnboardingOption(
      title: 'Legerement actif',
      subtitle: 'Exercice leger 1 a 3 jours/semaine',
      iconName: 'walk',
      selected: true,
    ),
    const OnboardingOption(
      title: 'Moderement actif',
      subtitle: 'Exercice modere 3 a 5 jours/semaine',
      iconName: 'fitness',
    ),
    const OnboardingOption(
      title: 'Tres actif',
      subtitle: 'Exercice intense 6 a 7 jours/semaine',
      iconName: 'self_improvement',
    ),
  ];

  final List<OnboardingOption> _mealTiming = [
    const OnboardingOption(
      title: 'Leve-tot',
      subtitle: '',
      iconName: 'light_mode',
      selected: true,
    ),
    const OnboardingOption(
      title: '3 repas classiques',
      subtitle: '',
      iconName: 'restaurant',
    ),
    const OnboardingOption(
      title: 'Jeune intermittent',
      subtitle: '',
      iconName: 'timer',
    ),
    const OnboardingOption(
      title: 'Tard le soir',
      subtitle: '',
      iconName: 'bed',
    ),
    const OnboardingOption(
      title: 'Collations frequentes',
      subtitle: '',
      iconName: 'cookie',
      selected: true,
    ),
  ];

  String _customAversionsInput = '';
  String _ageInput = '';
  String _heightCmInput = '';
  String _currentWeightKgInput = '';
  String _targetWeightKgInput = '';
  bool _profileValidationRequested = false;

  List<OnboardingOption> get goals => List.unmodifiable(_goals);
  List<OnboardingOption> get dietStyles => List.unmodifiable(_dietStyles);
  List<OnboardingOption> get allergies => List.unmodifiable(_allergies);
  List<OnboardingOption> get activityLevels =>
      List.unmodifiable(_activityLevels);
  List<OnboardingOption> get mealTiming => List.unmodifiable(_mealTiming);
  String get customAversionsInput => _customAversionsInput;
  String get ageInput => _ageInput;
  String get heightCmInput => _heightCmInput;
  String get currentWeightKgInput => _currentWeightKgInput;
  String get targetWeightKgInput => _targetWeightKgInput;

  String get selectedGoalTitle => _selectedTitle(_goals);
  String get selectedDietStyleTitle => _selectedTitle(_dietStyles);
  String get selectedActivityLevelTitle => _selectedTitle(_activityLevels);
  List<String> get selectedAllergyTitles => _selectedTitles(_allergies);
  List<String> get selectedMealTimingTitles => _selectedTitles(_mealTiming);
  List<String> get customAversions =>
      _splitCustomAversions(_customAversionsInput);
  bool get isProfileValid => profileValidationMessage == null;
  bool get shouldShowProfileValidationMessage =>
      _profileValidationRequested && profileValidationMessage != null;

  String? get profileValidationMessage {
    if (_parsePositiveInt(_ageInput) == null ||
        _parsePositiveInt(_heightCmInput) == null ||
        _parsePositiveDouble(_currentWeightKgInput) == null ||
        _parsePositiveDouble(_targetWeightKgInput) == null) {
      return 'Renseignez vos mesures.';
    }

    return null;
  }

  void selectGoal(String title) => _selectSingle(_goals, title);
  void selectActivityLevel(String title) =>
      _selectSingle(_activityLevels, title);
  void selectDietStyle(String title) => _selectSingle(_dietStyles, title);
  void toggleAllergy(String title) => _toggle(_allergies, title);
  void toggleMealTiming(String title) => _toggle(_mealTiming, title);
  void updateCustomAversions(String value) => _updateInput(
    value: value,
    apply: (nextValue) => _customAversionsInput = nextValue,
  );
  void updateAge(String value) =>
      _updateInput(value: value, apply: (nextValue) => _ageInput = nextValue);
  void updateHeightCm(String value) => _updateInput(
    value: value,
    apply: (nextValue) => _heightCmInput = nextValue,
  );
  void updateCurrentWeightKg(String value) => _updateInput(
    value: value,
    apply: (nextValue) => _currentWeightKgInput = nextValue,
  );
  void updateTargetWeightKg(String value) => _updateInput(
    value: value,
    apply: (nextValue) => _targetWeightKgInput = nextValue,
  );

  UserProfile? submitProfile() {
    _profileValidationRequested = true;
    final profile = buildProfile();
    notifyListeners();
    return profile;
  }

  UserProfile? buildProfile() {
    final age = _parsePositiveInt(_ageInput);
    final heightCm = _parsePositiveInt(_heightCmInput);
    final currentWeightKg = _parsePositiveDouble(_currentWeightKgInput);
    final targetWeightKg = _parsePositiveDouble(_targetWeightKgInput);

    if (age == null ||
        heightCm == null ||
        currentWeightKg == null ||
        targetWeightKg == null) {
      return null;
    }

    return UserProfile(
      goal: selectedGoalTitle,
      dietStyle: selectedDietStyleTitle,
      allergies: selectedAllergyTitles,
      customAversions: customAversions,
      activityLevel: selectedActivityLevelTitle,
      mealTiming: selectedMealTimingTitles,
      age: age,
      heightCm: heightCm,
      currentWeightKg: currentWeightKg,
      targetWeightKg: targetWeightKg,
    );
  }

  void _selectSingle(List<OnboardingOption> options, String title) {
    for (var index = 0; index < options.length; index += 1) {
      options[index] = options[index].copyWith(
        selected: options[index].title == title,
      );
    }
    notifyListeners();
  }

  void _toggle(List<OnboardingOption> options, String title) {
    final index = options.indexWhere((option) => option.title == title);
    if (index == -1) {
      return;
    }

    options[index] = options[index].copyWith(
      selected: !options[index].selected,
    );
    notifyListeners();
  }

  void _updateInput({
    required String value,
    required ValueChanged<String> apply,
  }) {
    apply(value);
    notifyListeners();
  }

  String _selectedTitle(List<OnboardingOption> options) {
    return options.firstWhere((option) => option.selected).title;
  }

  List<String> _selectedTitles(List<OnboardingOption> options) {
    return options
        .where((option) => option.selected)
        .map((option) => option.title)
        .toList(growable: false);
  }

  List<String> _splitCustomAversions(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  int? _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }

    return parsed;
  }

  double? _parsePositiveDouble(String value) {
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return null;
    }

    return parsed;
  }
}
