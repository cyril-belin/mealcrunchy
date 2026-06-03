import 'package:flutter/material.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.scrollable = true,
    this.padding = const EdgeInsets.fromLTRB(24, 20, 24, 32),
    super.key,
  });

  final Widget child;
  final bool scrollable;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child: Padding(padding: padding, child: child),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}
