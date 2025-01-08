import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/features/sign/sign_module.dart';

import '../../routes/routes.dart';

import '../urgency/urgency_module.dart';
import 'necessary_module.dart';
import 'presentation/pages/home_page.dart';

class HomeModule extends Module {
  static const String route = '/home/';
  @override
  List<Module> get imports => [
        SignModule(),
        NecessaryModule(),
        UrgencyModule(),
      ];

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => HomePage(),
    );
  }
}
