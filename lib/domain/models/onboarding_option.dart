class OnboardingOption {
  const OnboardingOption({
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.selected = false,
  });

  final String title;
  final String subtitle;
  final String iconName;
  final bool selected;

  OnboardingOption copyWith({bool? selected}) {
    return OnboardingOption(
      title: title,
      subtitle: subtitle,
      iconName: iconName,
      selected: selected ?? this.selected,
    );
  }
}
