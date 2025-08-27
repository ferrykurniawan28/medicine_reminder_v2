part of 'routes.dart';

class AddReminderModule extends Module {
  @override
  void routes(r) {
    r.child('/',
        child: (_) => AddReminderScreen(
              assignedUser: r.args.data['assignedUser'],
              isParental: r.args.data['isParental'] ?? false,
            ));
    r.child('/routine-select',
        child: (_) => RoutineSelectionScreen(
              container: r.args.data['container'],
              assignedUser: r.args.data['assignedUser'],
              isParental: r.args.data['isParental'] ?? false,
            ));
    r.child('/once-twice',
        child: (_) => OnceTwiceDailyPage(
              assignedUser: r.args.data['assignedUser'],
              container: r.args.data['container'],
              isOnce: r.args.data['isOnce'],
              isParental: r.args.data['isParental'] ?? false,
            ));
    r.child('/multiple-times',
        child: (_) => MultipleTimesDaily(
              assignedUser: r.args.data['assignedUser'],
              container: r.args.data['container'],
              howManyTimes: r.args.data['howManyTimes'],
              isParental: r.args.data['isParental'] ?? false,
            ));
    r.child('/specific-days',
        child: (_) => SpecificDays(
              assignedUser: r.args.data['assignedUser'],
              container: r.args.data['container'],
              days: r.args.data['days'],
              isParental: r.args.data['isParental'] ?? false,
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
