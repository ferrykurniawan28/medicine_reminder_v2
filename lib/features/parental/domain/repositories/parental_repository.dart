import 'package:medicine_reminder/features/parental/domain/entities/parental.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';

abstract class ParentalRepository {
  // Local operations
  Future<List<Parental>> getParentals(int userId);
  Future<List<Parental>> getParentalsByParentalId(int parentalId);
  Future<Parental?> getParental(int id);
  Future<void> addParental(Parental parental, int userId);
  Future<void> updateParental(Parental parental);
  Future<void> deleteParental(int id);
  Future<bool> parentalExists(int userId, int parentalId);
  Future<Parental?> getParentalByIds(int userId, int parentalId);

  // Remote operations
  // Future<List<Parental>> fetchParentalsFromServer(int userId);
  Future<List<Reminder>> getParentalReminders(int parentalId);
  Future<void> syncParentalToServer(Parental parental);
  // Future<void> updateParentalOnServer(Parental parental);
  // Future<void> deleteParentalOnServer(int parentalId);
}
