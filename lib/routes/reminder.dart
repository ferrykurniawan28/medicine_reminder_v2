part of 'routes.dart';

class AddReminderModule extends Module {
  @override
  void routes(r) {
    // r.child('/', child: (_) => const AddReminderContent());
    // r.child(
    //   '/container-list',
    //   child: (_) => ContainerListPage(
    //     device: r.args.data['device'],
    //     onContainerSelected: r.args.data['onContainerSelected'],
    //   ),
    // );
    // r.child('/medication-routine',
    //     child: (_) => MedicationRoutinePage(
    //           medicineName: r.args.data['medicineName'],
    //           onRoutineSelected: r.args.data['onRoutineSelected'],
    //         ));
    // r.child('/once-daily',
    //     child: (_) => OnceDailyPage(
    //           medicineName: r.args.data['medicineName'],
    //           onSave: r.args.data['onSave'],
    //         ));
  }
  // @override
  // List<ModularRoute> get routes => [
  //       ChildRoute(
  //         '/',
  //         child: (context, args) => const AddReminderContent(),
  //         children: [
  //           ChildRoute(
  //             '/container-list',
  //             child: (context, args) => _ContainerListPage(
  //               device: args.data['device'],
  //               onContainerSelected: args.data['onContainerSelected'],
  //             ),
  //           ),
  //           ChildRoute(
  //             '/medication-routine',
  //             child: (context, args) => _MedicationRoutinePage(
  //               medicineName: args.data['medicineName'],
  //               onRoutineSelected: args.data['onRoutineSelected'],
  //             ),
  //           ),
  //           ChildRoute(
  //             '/once-daily',
  //             child: (context, args) => _OnceDailyPage(
  //               medicineName: args.data['medicineName'],
  //               onSave: args.data['onSave'],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ];
}
