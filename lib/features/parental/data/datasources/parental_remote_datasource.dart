import 'package:medicine_reminder/features/appointment/data/models/appointment_model.dart';
import 'package:medicine_reminder/features/appointment/domain/entities/appointment.dart';
import 'package:medicine_reminder/features/device/domain/entities/device.dart';
import 'package:medicine_reminder/features/reminder/data/models/reminder_model.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

import '../../domain/entities/parental.dart';

/// Abstract class defining the contract for parental remote data source operations
abstract class ParentalRemoteDataSource {
  /// Fetch all parental relationships for a specific user from the server
  /// Returns list of [Parental] where the user is the parent
  Future<List<Parental>> fetchParentals(int userId);

  /// Add a new parental relationship to the server
  /// Creates a new relationship between parent and child
  Future<void> addParental(Parental parental);

  /// Delete a parental relationship on the server
  /// Removes the relationship from remote storage
  Future<void> deleteParental(int parentalId);

  Future<List<Reminder>> fetchParentalReminders(int parentalId);
  Future<List<Appointment>> fetchParentalAppointments(int parentalId);
  Future<Device> fetchParentalDevice(int parentalId);

  Future<void> createParentalAppointment(
      AppointmentModel appointment, int parentalId);
  Future<void> createParentalReminder(ReminderModel reminder, int parentalId);

  // /// Generate QR code for parental invitation
  // /// Returns QR code data for parent-child relationship setup
  // Future<String> generateParentalQR(int userId);

  // /// Accept parental relationship via QR code
  // /// Establishes relationship using QR code data
  // Future<void> acceptParentalQR(String qrData, int childUserId);
}
