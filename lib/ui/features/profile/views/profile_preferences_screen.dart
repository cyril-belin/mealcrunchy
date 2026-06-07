import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_icon.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePreferencesScreen extends StatelessWidget {
  const ProfilePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return switch (viewModel.preferencesState) {
      ViewLoading<List<PreferenceItem>>() => const AppScaffold(
        scrollable: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      ViewError<List<PreferenceItem>>(message: final message) =>
        _ProfileErrorScaffold(message: message, onRetry: viewModel.load),
      ViewData<List<PreferenceItem>>(data: final preferences) =>
        _ProfileContent(preferences: preferences),
    };
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.preferences});

  final List<PreferenceItem> preferences;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.mealPlan),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: Text(
                  'Profil',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          SoftCard(
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 70,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Alex Rivers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'alex.rivers@example.com',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: const [
                    Expanded(
                      child: _ProfileStat(value: '72.5 kg', label: 'Actuel'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStat(value: '68.0 kg', label: 'Cible'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStat(value: '1 850', label: 'Cal/jour'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Préférences personnelles',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.go(AppRoutes.onboardingGoals),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refaire le quiz'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...preferences.map(
            (preference) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PreferenceRow(preference: preference),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Paramètres du compte',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const _SettingsRow(
            icon: Icons.notifications_active_rounded,
            title: 'Notifications',
            subtitle: 'Rappels de repas et rapports hebdomadaires',
            message:
                'Les paramètres de notification ne sont pas encore connectés.',
          ),
          const _SettingsRow(
            icon: Icons.lock_rounded,
            title: 'Confidentialité et sécurité',
            subtitle: 'Gérer vos données et votre compte',
            message:
                'Les paramètres de confidentialité ne sont pas encore connectés.',
          ),
          const _SettingsRow(
            icon: Icons.help_outline_rounded,
            title: 'Centre d\'aide',
            subtitle: 'FAQ et support',
            message: 'Le centre d\'aide n\'est pas encore connecté.',
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.auth),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Se déconnecter'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}

class _ProfileErrorScaffold extends StatelessWidget {
  const _ProfileErrorScaffold({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger le profil.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({required this.preference});

  final PreferenceItem preference;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.byToken(preference.colorToken);
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(appIcon(preference.iconName), color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preference.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  preference.value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceVariant,
        child: Icon(icon, color: AppColors.secondaryText),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
