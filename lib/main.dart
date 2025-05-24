import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource_impl.dart';
import 'package:medicine_reminder/features/features.dart';
// import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
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
    // AppointmentLocalDataSourceImpl().deleteAllAppointments();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeviceBloc()),
        BlocProvider(create: (context) => ParentalBloc()),
        BlocProvider(create: (context) => AppointmentBloc()),
        BlocProvider(create: (context) => ReminderBloc()),
      ],
      child: MaterialApp.router(
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          fontFamily: 'Montserrat ',
          appBarTheme: const AppBarTheme(
            backgroundColor: kPrimaryColor,
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                fontFamily: 'Montserrat ',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: kPrimaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
          toggleButtonsTheme: const ToggleButtonsThemeData(
            selectedColor: kPrimaryColor,
            color: Colors.white,
            fillColor: kPrimaryColor,
          ),
          switchTheme: const SwitchThemeData(
            thumbColor: WidgetStatePropertyAll(Colors.white),
            // trackColor: WidgetStatePropertyAll(kPrimaryColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
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
