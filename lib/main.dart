import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mealcrunchy/data/services/observability_service.dart';
import 'package:mealcrunchy/firebase_options.dart';
import 'package:mealcrunchy/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  await _initializeFirebase();
  usePathUrlStrategy();
  runApp(MealCrunchyApp(observabilityService: FirebaseObservabilityService()));
}

const _useFunctionsEmulator = bool.fromEnvironment('USE_FUNCTIONS_EMULATOR');
const _appCheckReCaptchaSiteKey = String.fromEnvironment(
  'APP_CHECK_RECAPTCHA_SITE_KEY',
);

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _activateAppCheck();
  _configureCrashReporting();
  if (kDebugMode && _useFunctionsEmulator) {
    FirebaseFunctions.instanceFor(
      region: 'europe-west1',
    ).useFunctionsEmulator('localhost', 5001);
  }
}

Future<void> _activateAppCheck() {
  return FirebaseAppCheck.instance.activate(
    providerWeb: kDebugMode
        ? WebDebugProvider()
        : _appCheckReCaptchaSiteKey.isEmpty
        ? null
        : ReCaptchaEnterpriseProvider(_appCheckReCaptchaSiteKey),
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleAppAttestWithDeviceCheckFallbackProvider(),
  );
}

void _configureCrashReporting() {
  if (kIsWeb) {
    return;
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    return true;
  };
}
