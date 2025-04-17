part of 'routes.dart';

class AddReminderModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const AddReminderScreen());
    r.child('/routine-select',
        child: (_) => RoutineSelectionScreen(
              container: r.args.data['container'],
            ));
    r.child('/once-twice',
        child: (_) => OnceTwiceDailyPage(
              container: r.args.data['container'],
              isOnce: r.args.data['isOnce'],
            ));
    r.child('/multiple-times',
        child: (_) => MultipleTimesDaily(
              container: r.args.data['container'],
              howManyTimes: r.args.data['howManyTimes'],
            ));
    r.child('/specific-days',
        child: (_) => SpecificDays(
              container: r.args.data['container'],
              days: r.args.data['days'],
            ));
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
}
