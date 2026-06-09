import 'package:mealcrunchy/data/services/ai_proxy_service.dart';
import 'package:mealcrunchy/l10n/app_localizations.dart';

String? remainingRegenerationsMessage(
  AppLocalizations l10n,
  AiQuotaUsage? usage,
) {
  if (usage == null) {
    return null;
  }

  return l10n.remainingRegenerations(usage.remaining);
}

String? remainingReplacementsMessage(
  AppLocalizations l10n,
  AiQuotaUsage? usage, {
  bool includeSuccessPrefix = false,
}) {
  if (usage == null) {
    return null;
  }

  final quotaMessage = l10n.remainingReplacements(usage.remaining);
  if (!includeSuccessPrefix) {
    return quotaMessage;
  }

  return l10n.mealReplacedWithQuota(quotaMessage);
}
