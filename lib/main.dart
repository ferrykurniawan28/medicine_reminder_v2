import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/features.dart';
import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:medicine_reminder/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/get_reminders.dart';
import 'package:medicine_reminder/features/reminder/domain/usecases/add_reminder.dart'
    as usecases;
import 'package:medicine_reminder/features/reminder/domain/usecases/delete_reminder.dart'
    as usecases;
import 'package:medicine_reminder/features/reminder/domain/usecases/update_reminder.dart'
    as usecases;
import 'package:medicine_reminder/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(module: AppRoute(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    ReminderLocalDataSource().clearReminders();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeviceBloc()),
        BlocProvider(create: (context) => ParentalBloc()),
        BlocProvider(create: (context) => AppointmentBloc()),
        BlocProvider(
          create: (context) => ReminderBloc(
            getReminders: GetReminders(ReminderRepositoryImpl()),
            addReminder: usecases.AddReminder(ReminderRepositoryImpl()),
            deleteReminder: usecases.DeleteReminder(ReminderRepositoryImpl()),
            updateReminder: usecases.UpdateReminder(ReminderRepositoryImpl()),
          ),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat ',
          textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontFamily: 'Montserrat ',
                fontSize: 24,
                fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 14),
            bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 12),
          ),
        ),
      ),
    );
  }
}
