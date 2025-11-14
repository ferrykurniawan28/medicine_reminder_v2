import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/core/services/scan_barcode.dart';
import 'package:medicine_reminder/features/analytics/presentation/pages/analytics_dashboard_page.dart';
import 'package:medicine_reminder/features/notification/presentation/pages/notification.dart';
// import 'package:medicine_reminder/features/analytics/presentation/pages/analytics_page.dart';
import 'package:medicine_reminder/features/record/presentation/pages/medical_records_page.dart';
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
          // ChildRoute(
          //   '/detail',
          //   child: (_) => ParentalDetail(
          //     parental: r.args.data['parental'],
          //   ),
          //   children: [
          //     ChildRoute(
          //       '/reminder',
          //       child: (_) => ReminderList(
          //         parental: r.args.data['parental'],
          //       ),
          //     ),
          //     ChildRoute(
          //       '/appointment',
          //       child: (_) => AppointmentList(
          //         parental: r.args.data['parental'],
          //       ),
          //     ),
          //     ChildRoute(
          //       '/device',
          //       child: (_) => DeviceParental(
          //         parental: r.args.data['parental'],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      ChildRoute('/device', child: (_) => const DeviceView(), children: [
        // ChildRoute('/device-control-list',
        //     child: (_) => const DeviceControlList()),
        // ChildRoute('/device-control-list/',
        //     child: (_) =>
        //         const DeviceControlList()), // Alias for trailing slash
      ]),
    ]);
    // r.child('/parental-detail',
    //     child: (_) => ParentalDetail(
    //           parental: r.args.data['parental'],
    //         ));
    r.child('/device-control-list', child: (_) => const DeviceControlList());
    r.child('/parental/detail',
        child: (child) => ParentalDetail(
              parental: r.args.data['parental'],
            ),
        children: [
          ChildRoute(
            '/',
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
        ]);
    r.child('/records', child: (_) => const MedicalRecordsPage());
    r.child('/analytics', child: (_) => const AnalyticsPage());
    // r.child('/fcm-test', child: (_) => const FCMTestScreen());
    r.child('/notification', child: (_) => const NotificationPage());
    r.module('/auth', module: AuthRoutes());
    r.module('/reminder', module: AddReminderModule());
    r.child('/scan-barcode',
        child: (_) => ScanBarcodePage(
              title: r.args.data['title'],
              onScanned: r.args.data['onScanned'],
            ));
  }
}
