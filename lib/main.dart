import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/routes/routes.dart';

void main() {
  runApp(ModularApp(module: AppRoute(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    return MaterialApp.router(
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
    );
  }
}
