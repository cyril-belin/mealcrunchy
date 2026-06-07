import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mealcrunchy/firebase_options.dart';
import 'package:mealcrunchy/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  usePathUrlStrategy();
  runApp(const MealCrunchyApp());
}

const _useFunctionsEmulator = bool.fromEnvironment('USE_FUNCTIONS_EMULATOR');

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode && _useFunctionsEmulator) {
    FirebaseFunctions.instanceFor(
      region: 'europe-west1',
    ).useFunctionsEmulator('localhost', 5001);
  }
}
