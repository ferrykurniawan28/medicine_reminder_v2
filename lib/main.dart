import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/appointment/data/datasources/appointment_local_datasource_impl.dart';
import 'package:medicine_reminder/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/auth/bloc/auth_bloc.dart';
import 'package:medicine_reminder/features/device/data/repositories/device_repository_impl_new.dart'
    as device_repo_offline;
import 'package:medicine_reminder/features/features.dart';
import 'package:medicine_reminder/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:medicine_reminder/features/parental/data/datasources/parental_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource_impl.dart';
import 'package:medicine_reminder/features/reminder/data/datasources/reminder_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/features/record/data/datasources/medical_record_local_datasource_impl.dart';
import 'package:medicine_reminder/features/record/data/datasources/medical_record_remote_datasource_impl.dart';
import 'package:medicine_reminder/features/record/data/repositories/medical_record_repository_impl.dart';
// import 'package:medicine_reminder/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:medicine_reminder/core/services/sync_manager.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource_impl.dart';
import 'package:medicine_reminder/features/parental/data/datasources/parental_local_datasource_impl.dart';
import 'package:medicine_reminder/features/parental/data/repositories/parental_repository_impl.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_remote_datasource_impl.dart';
import 'package:medicine_reminder/core/connectivity/connectivity.dart';
import 'package:medicine_reminder/core/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicine_reminder/core/services/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set background message handler for FCM
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize critical services first
  await _initializeCoreServices();

  // Initialize UserBloc with saved credentials
  final userBloc = await _initializeUserBloc();

  runApp(ModularApp(
    module: AppRoute(),
    child: MainApp(userBloc: userBloc),
  ));
}

Future<void> _initializeCoreServices() async {
  try {
    // Initialize connectivity service first
    final connectivityService = ConnectivityService();
    await connectivityService.initialize();

    // Initialize database by creating and accessing it once
    final appointmentLocalDataSource = AppointmentLocalDataSourceImpl();
    await appointmentLocalDataSource.database; // This initializes the database

    // Initialize reminder database
    final reminderLocalDataSource = ReminderLocalDataSourceImpl();
    await reminderLocalDataSource
        .database; // This initializes the reminder database

    // Initialize parental database
    final parentalDatabase = ParentalLocalDataSourceImpl();
    await parentalDatabase.database; // This initializes the parental database

    // Initialize FCM service
    await FCMService().initialize();

    debugPrint('✅ Core services initialized successfully');
  } catch (e) {
    debugPrint('❌ Failed to initialize core services: $e');
  }
}

Future<UserBloc> _initializeUserBloc() async {
  final userBloc = UserBloc();

  // Load saved user ID and initialize user state
  try {
    final userId = await SharedPreference.getInt('userId');
    if (userId > 0) {
      userBloc.add(LoadUser(userId));
      debugPrint('✅ User loaded with ID: $userId');
    } else {
      debugPrint('ℹ️ No saved user found');
    }
  } catch (e) {
    debugPrint('❌ Failed to load user: $e');
  }

  return userBloc;
}

// Helper function to check connectivity
bool _isOnline() {
  // Use the connectivity service for more accurate status
  return ConnectivityService().isConnected;
}

class MainApp extends StatelessWidget {
  final UserBloc userBloc;

  const MainApp({required this.userBloc, super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final deviceRepo = device_repo_offline.DeviceRepositoryImpl(
              localDataSource: DeviceLocalDataSourceImpl(),
              remoteDataSource: DeviceRemoteDataSourceImpl(NetworkService()),
              isOnline: _isOnline,
            );
            return DeviceBloc(deviceRepo);
          },
        ),
        BlocProvider(
          create: (context) {
            final parentalLocalDataSource = ParentalLocalDataSourceImpl();
            final parentalRepository = ParentalRepositoryImpl(
              localDataSource: parentalLocalDataSource,
              remoteDataSource: ParentalRemoteDataSourceImpl(NetworkService()),
              isOnline: _isOnline,
            );
            return ParentalBloc(parentalRepository);
          },
        ),
        BlocProvider(
          create: (context) {
            // Use properly initialized data sources
            final localDataSource = AppointmentLocalDataSourceImpl();
            final syncManager = SyncManager(
              db: localDataSource.databaseSync,
              connectivity: Connectivity(),
              appointmentLocalDataSource: localDataSource,
              appointmentRemoteDataSource:
                  AppointmentRemoteDataSourceImpl(NetworkService()),
            );

            final repo = AppointmentRepositoryImpl(
              localDataSource,
              remoteDataSource:
                  AppointmentRemoteDataSourceImpl(NetworkService()),
              isOnline: _isOnline,
              syncManager: syncManager,
            );
            return AppointmentBloc(repo);
          },
        ),
        BlocProvider(create: (context) {
          final localDataSource = ReminderLocalDataSourceImpl();
          // Create SyncManager with properly initialized data sources
          final syncManager = SyncManager(
            db: localDataSource.databaseSync,
            connectivity: Connectivity(),
            appointmentLocalDataSource: AppointmentLocalDataSourceImpl(),
            appointmentRemoteDataSource:
                AppointmentRemoteDataSourceImpl(NetworkService()),
            reminderLocalDataSource: localDataSource,
            reminderRemoteDataSource:
                ReminderRemoteDataSourceImpl(NetworkService()),
          );
          final reminderRepository = ReminderRepositoryImpl(localDataSource,
              remoteDataSource: ReminderRemoteDataSourceImpl(NetworkService()),
              isOnline: _isOnline,
              syncManager: syncManager);
          return ReminderBloc(reminderRepository: reminderRepository);
        }),
        BlocProvider(create: (context) => userBloc),
        BlocProvider(create: (context) {
          final medicalRecordRepository = MedicalRecordRepositoryImpl(
            MedicalRecordLocalDataSourceImpl(),
            remoteDataSource:
                MedicalRecordRemoteDataSourceImpl(NetworkService()),
            isOnline: _isOnline,
          );
          return MedicalRecordBloc(
              medicalRecordRepository: medicalRecordRepository);
        }),
        BlocProvider(
            create: (context) => AuthBloc(
                // userBloc: ReadContext(context).read<UserBloc>(),
                )),
        BlocProvider(create: (context) => NotificationBloc()),
      ],
      child: ConnectivityListener(
        onConnected: () {
          // Trigger sync when connection is restored
          debugPrint('🔄 Connection restored - triggering sync');
        },
        onDisconnected: () {
          // Handle offline mode
          debugPrint('⚠️ Connection lost - entering offline mode');
        },
        child: ConnectivityBanner(
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
        ),
      ),
    );
  }
}
