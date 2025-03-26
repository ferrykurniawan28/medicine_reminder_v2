import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/appointment/bloc/appointment_bloc.dart';
import 'package:medicine_reminder/features/device/bloc/device_bloc.dart';
import 'package:medicine_reminder/features/parental/bloc/parental_bloc.dart';
import 'package:medicine_reminder/routes/routes.dart';

void main() {
  runApp(ModularApp(module: AppRoute(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeviceBloc()),
        BlocProvider(create: (context) => ParentalBloc()),
        BlocProvider(create: (context) => AppointmentBloc()),
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
