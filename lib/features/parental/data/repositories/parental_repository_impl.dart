import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';
import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

import '../../domain/entities/parental.dart';
import '../../domain/repositories/parental_repository.dart';
import '../datasources/parental_local_datasource.dart';
import '../datasources/parental_remote_datasource.dart';

class ParentalRepositoryImpl implements ParentalRepository {
  final ParentalLocalDataSource localDataSource;
  final ParentalRemoteDataSource remoteDataSource;
  final bool Function()? isOnline;

  ParentalRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.isOnline,
  });

  // Local operations
  @override
  Future<List<Parental>> getParentals(int userId) async {
    if (isOnline == null || !isOnline!()) {
      // If offline, return local data
      return await localDataSource.getParentals(userId);
    } else {
      try {
        final remoteParentals = await remoteDataSource.fetchParentals(userId);

        // Sync to local database - only insert if server ID doesn't exist
        for (final parental in remoteParentals) {
          if (parental.id != null) {
            // Check if record with this server ID already exists
            final exists =
                await localDataSource.parentalExistsById(parental.id!);
            print('Parental record ${parental.id} exists: $exists');
            if (!exists) {
              // Insert new relationship with server ID
              await localDataSource.addParental(parental, userId);
            }
            // If exists, skip insertion (don't insert duplicates)
          }
        }
        print('Fetched parentals from remote: $remoteParentals');

        return remoteParentals;
      } catch (e) {
        print('Error fetching parentals from remote: $e');
        // Fallback to local data if remote fails
        return await localDataSource.getParentals(userId);
      }
    }
  }

  @override
  Future<List<Reminder>> getParentalReminders(int parentalId) async {
    try {
      return await remoteDataSource.fetchParentalReminders(parentalId);
    } catch (e) {
      print('Error fetching parental reminders: $e');
      return [];
    }
  }

  @override
  Future<List<Appointment>> getParentalAppointments(int parentalId) async {
    try {
      return await remoteDataSource.fetchParentalAppointments(parentalId);
    } catch (e) {
      print('Error fetching parental appointments: $e');
      return [];
    }
  }

  @override
  Future<Device> getParentalDevice(int parentalId) async {
    try {
      return await remoteDataSource.fetchParentalDevice(parentalId);
    } catch (e) {
      print('Error fetching parental device: $e');
      throw Exception('Failed to fetch parental device: $e');
    }
  }

  @override
  Future<void> createParentalAppointment(
      Appointment appointment, int parentalId) async {
    try {
      final appointmentModel = AppointmentModel.fromDomain(appointment);
      await remoteDataSource.createParentalAppointment(
          appointmentModel, parentalId);
    } catch (e) {
      print('Error creating parental appointment: $e');
      throw Exception('Failed to create parental appointment: $e');
    }
  }

  @override
  Future<void> createParentalReminder(Reminder reminder, int parentalId) async {
    try {
      final reminderModel = ReminderModel.fromEntity(reminder);
      await remoteDataSource.createParentalReminder(reminderModel, parentalId);
    } catch (e) {
      print('Error creating parental reminder: $e');
      throw Exception('Failed to create parental reminder: $e');
    }
  }

  @override
  Future<List<Parental>> getParentalsByParentalId(int parentalId) async {
    return await localDataSource.getParentalsByParentalId(parentalId);
  }

  @override
  Future<Parental?> getParental(int id) async {
    return await localDataSource.getParental(id);
  }

  @override
  Future<void> addParental(int userId, String parentalId) async {
    // If online, create on server first then fetch and save to local
    if (isOnline != null && isOnline!()) {
      try {
        // Create the relationship on server (only needs user IDs)
        await remoteDataSource.createParentalRelationship(userId, parentalId);
        print('Parental relationship created on server');

        // Fetch all parentals from server to get the newly created one with full data
        final parentals = await remoteDataSource.fetchParentals(userId);

        // Save all fetched parentals to local (including the new one)
        for (final fetchedParental in parentals) {
          if (fetchedParental.id != null) {
            final exists =
                await localDataSource.parentalExistsById(fetchedParental.id!);
            if (!exists) {
              await localDataSource.addParental(fetchedParental, userId);
            }
          }
        }
        print('Parental relationship saved to local database');
      } catch (e) {
        print('Failed to create parental on server: $e');
        throw Exception('Failed to create parental relationship: $e');
      }
    } else {
      // If offline, save placeholder to local for later sync
      throw Exception('Cannot add parental relationship while offline');
    }
  }

  @override
  Future<void> updateParental(Parental parental) async {
    await localDataSource.updateParental(parental);
  }

  @override
  Future<void> deleteParental(int id) async {
    await localDataSource.deleteParental(id);
  }

  @override
  Future<bool> parentalExists(int userId, int parentalId) async {
    return await localDataSource.parentalExists(parentalId);
  }

  @override
  Future<Parental?> getParentalByIds(int userId, int parentalId) async {
    return await localDataSource.getParentalByIds(userId, parentalId);
  }

  @override
  Future<void> syncParentalToServer(int userId, String parentalId) async {
    try {
      await remoteDataSource.createParentalRelationship(userId, parentalId);
      print('Parental relationship synced to server');
    } catch (e) {
      print('Failed to sync parental to server: $e');
      throw Exception('Failed to sync parental relationship: $e');
    }
  }
}
