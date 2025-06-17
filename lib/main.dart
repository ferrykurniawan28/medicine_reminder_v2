import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource_impl.dart';
import 'package:medicine_reminder/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/auth/bloc/auth_bloc.dart';
import 'package:medicine_reminder/features/device/data/repositories/device_repository_impl.dart';
import 'package:medicine_reminder/features/features.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
// import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:medicine_reminder/core/services/sync_manager.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource_impl.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_remote_datasource_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database asynchronously
  final localDataSource = AppointmentLocalDataSourceImpl();
  final database = await localDataSource.database; // Use asynchronous getter

  // Create SyncManager after database initialization
  final syncManager = SyncManager(
    db: database,
    connectivity: Connectivity(),
    appointmentLocalDataSource: localDataSource,
    appointmentRemoteDataSource:
        AppointmentRemoteDataSourceImpl(NetworkService()),
  );

  runApp(
      ModularApp(module: AppRoute(), child: MainApp(syncManager: syncManager)));
}

class MainApp extends StatelessWidget {
  final SyncManager syncManager;

  const MainApp({required this.syncManager, super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final deviceRepo = DeviceRepositoryImpl(
              localDataSource: DeviceLocalDataSourceImpl(),
              remoteDataSource: DeviceRemoteDataSourceImpl(NetworkService()),
              isOnline: () => true,
            );
            return DeviceBloc(deviceRepo);
          },
        ),
        BlocProvider(create: (context) => ParentalBloc()),
        BlocProvider(
          create: (context) {
            final repo = AppointmentRepositoryImpl(
              AppointmentLocalDataSourceImpl(),
              remoteDataSource:
                  AppointmentRemoteDataSourceImpl(NetworkService()),
              isOnline: () => true,
              syncManager: syncManager,
            );
            return AppointmentBloc(repo);
          },
        ),
        BlocProvider(create: (context) => ReminderBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(
            create: (context) => AuthBloc(
                  userBloc: ReadContext(context).read<UserBloc>(),
                )),
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
