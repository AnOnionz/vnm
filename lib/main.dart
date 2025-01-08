import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vnm/core/environment/env.dart';
import 'package:vnm/core/mixins/common.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/features/app/app_module.dart';
import 'package:vnm/features/app/presentation/pages/app.dart';

import 'core/firebase/firebase_remote_config_service.dart';
import 'firebase_options.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'firebase_options_stg.dart' as stag;

void main() async {
  await _initializeApp();
  runApp(ModularApp(
    module: AppModule(),
    child: FlexibleBuilder(
      designSize: Size(430, 934),
      child: const App(),
    ),
  ));
}

Future<void> _initializeApp() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Initialize Firebase
  final String? flavor =
      await MethodChannel('flavor').invokeMethod<String>('getFlavor');
  Fx.log('STARTED WITH FLAVOR: $flavor');

  // final firebaseOptions = switch (flavor) {
  //   'prod' => prod.DefaultFirebaseOptions.currentPlatform,
  //   'stag' => stag.DefaultFirebaseOptions.currentPlatform,
  //   'dev' => dev.DefaultFirebaseOptions.currentPlatform,
  //   _ => DefaultFirebaseOptions.currentPlatform,
  // };
  // await Firebase.initializeApp(options: firebaseOptions);

  // Initialize remote config
  // await FirebaseRemoteConfigService().initialize();
  // Initialize AppConfig
  AppConfig();
}
