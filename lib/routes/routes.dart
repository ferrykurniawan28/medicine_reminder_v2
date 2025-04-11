import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/ui/main/widgets/widgets.dart';
import 'package:medicine_reminder/ui/ui.dart';

import '../ui/auth/auth.dart';
import '../ui/main/main.dart';
import '../ui/onboarding/onboarding.dart';

part 'auth.dart';
part 'reminder.dart';

class AppRoute extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const Splash());
    r.child('/boarding', child: (_) => const Onboarding());
    r.child('/home', child: (_) => const MainPage());
    r.child(
      '/device/:deviceId',
      child: (_) => const Device(),
    );
    r.child(
      '/parental/:groupId',
      child: (_) =>
          GroupDetailPage(groupId: int.parse(r.args.params['groupId']!)),
    );
    r.module('/auth', module: AuthRoutes());
    r.module('/reminder', module: AddReminderModule());
  }
}
