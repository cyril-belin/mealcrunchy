import 'package:flutter/material.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_icon.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = AppColors.secondaryBackground,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 80, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.eco_rounded, color: AppColors.success, size: size * 0.54),
          Align(
            alignment: const Alignment(0.64, 0.58),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.success.withValues(alpha: 0.45),
              size: size * 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressPill extends StatelessWidget {
  const ProgressPill({required this.progress, this.label, super.key});

  final double progress;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String iconName;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.secondaryText;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: SoftCard(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.secondaryBackground,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(appIcon(iconName), color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceChipGrid extends StatelessWidget {
  const ChoiceChipGrid({required this.items, this.onSelected, super.key});

  final List<({String title, String iconName, bool selected})> items;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final color = item.selected
            ? AppColors.primary
            : AppColors.secondaryText;
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onSelected?.call(item.title),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: item.selected
                  ? AppColors.primary.withValues(alpha: 0.09)
                  : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: item.selected ? AppColors.primary : AppColors.outline,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(appIcon(item.iconName), size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    item.title,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
