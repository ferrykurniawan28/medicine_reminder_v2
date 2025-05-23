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
    r.child('/home', child: (_) => const MainPage(), children: [
      ChildRoute('/reminder', child: (_) => const Home()),
      ChildRoute('/appointment', child: (_) => const Appointment()),
      ChildRoute(
        '/parental',
        child: (_) => const ParentalMainPage(),
        children: [
          ChildRoute('/list', child: (_) => const ListParental()),
          ChildRoute(
            '/detail',
            child: (_) => ParentalDetail(
              parental: r.args.data['parental'],
            ),
            children: [
              ChildRoute(
                '/reminder',
                child: (_) => ReminderList(
                  parental: r.args.data['parental'],
                ),
              ),
              ChildRoute(
                '/appointment',
                child: (_) => AppointmentList(
                  parental: r.args.data['parental'],
                ),
              ),
              ChildRoute(
                '/device',
                child: (_) => DeviceParental(
                  parental: r.args.data['parental'],
                ),
              ),
            ],
          ),
        ],
      ),
      ChildRoute('/device', child: (_) => const DeviceView()),
    ]);
    // r.child(
    //   '/device/:deviceId',
    //   child: (_) => const DeviceView(),
    // );
    r.module('/auth', module: AuthRoutes());
    r.module('/reminder', module: AddReminderModule());
  }
}
