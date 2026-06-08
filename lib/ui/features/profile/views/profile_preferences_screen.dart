import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealcrunchy/domain/models/auth_account.dart';
import 'package:mealcrunchy/domain/models/preference_item.dart';
import 'package:mealcrunchy/domain/models/profile_preferences.dart';
import 'package:mealcrunchy/ui/core/routing/app_routes.dart';
import 'package:mealcrunchy/ui/core/state/view_state.dart';
import 'package:mealcrunchy/ui/core/theme/app_colors.dart';
import 'package:mealcrunchy/ui/core/widgets/app_icon.dart';
import 'package:mealcrunchy/ui/core/widgets/app_scaffold.dart';
import 'package:mealcrunchy/ui/core/widgets/design_primitives.dart';
import 'package:mealcrunchy/ui/features/auth/view_models/auth_view_model.dart';
import 'package:mealcrunchy/ui/features/onboarding/view_models/onboarding_view_model.dart';
import 'package:mealcrunchy/ui/features/profile/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePreferencesScreen extends StatelessWidget {
  const ProfilePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final account = context.watch<AuthViewModel>().account;

    return switch (viewModel.profileState) {
      ViewLoading<ProfilePreferences>() => const AppScaffold(
        scrollable: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      ViewError<ProfilePreferences>(message: final message) =>
        _ProfileErrorScaffold(message: message, onRetry: viewModel.load),
      ViewData<ProfilePreferences>(data: final profilePreferences) =>
        _ProfileContent(data: profilePreferences, account: account),
    };
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.data, required this.account});

  final ProfilePreferences data;
  final AuthAccount? account;

  @override
  Widget build(BuildContext context) {
    final profile = data.profile;
    final displayName = _displayName(account);
    final email = account?.email ?? 'Compte connecté';

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
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ProfileStat(
                        value: _formatWeight(profile.currentWeightKg),
                        label: 'Actuel',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStat(
                        value: _formatWeight(profile.targetWeightKg),
                        label: 'Cible',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStat(
                        value: _formatCalories(data.dailyTargetCalories),
                        label: 'Cal/jour',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (data.profileNeedsPlanRegeneration) ...[
            const SizedBox(height: 16),
            const _RegenerationBanner(),
          ],
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
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final started = await context
                      .read<OnboardingViewModel>()
                      .startProfileEdit();
                  if (!context.mounted) {
                    return;
                  }

                  if (started) {
                    context.go(AppRoutes.onboardingGoals);
                    return;
                  }

                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Profil indisponible pour modification.'),
                      ),
                    );
                },
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Modifier'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...data.preferenceItems.map(
            (preference) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PreferenceRow(preference: preference),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => context.read<AuthViewModel>().signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Se déconnecter'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  String _displayName(AuthAccount? account) {
    final name = account?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }

    return 'Utilisateur MealCrunchy';
  }

  String _formatWeight(double value) => '${value.toStringAsFixed(1)} kg';

  String _formatCalories(int? value) => value?.toString() ?? 'À revoir';
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

class _RegenerationBanner extends StatelessWidget {
  const _RegenerationBanner();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: AppColors.warning.withValues(alpha: 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan à régénérer',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Vos préférences ont changé. Régénérez votre plan pour aligner les prochains repas.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.generatingPlan),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Régénérer le plan'),
                ),
              ],
            ),
          ),
        ],
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
