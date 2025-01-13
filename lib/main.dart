import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fms/core/environment/env.dart';
import 'package:fms/core/mixins/common.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/features/app/app_module.dart';
import 'package:fms/features/app/presentation/pages/app.dart';

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

  final String? flavor =
      await MethodChannel('flavor').invokeMethod<String>('getFlavor');
  Fx.log('STARTED WITH FLAVOR: $flavor');

  AppConfig();
}
