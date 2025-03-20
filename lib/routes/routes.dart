import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/ui/ui.dart';

import '../ui/auth/auth.dart';
import '../ui/main/main.dart';
import '../ui/onboarding/onboarding.dart';

part 'auth.dart';

class AppRoute extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const Splash());
    r.child('/boarding', child: (_) => const Onboarding());
    r.child('/home', child: (_) => const MainPage());
    r.module('/auth', module: AuthRoutes());
  }
}
