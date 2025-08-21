import '../../domain/entities/parental.dart';

/// Abstract class defining the contract for parental local data source operations
abstract class ParentalLocalDataSource {
  /// Get all parental relationships for a specific user
  /// Returns list of [Parental] where the user is the parent
  Future<List<Parental>> getParentals(int userId);

  /// Get all parental relationships where the user is the managed user
  /// Returns list of [Parental] where the user is being managed by parents
  Future<List<Parental>> getParentalsByParentalId(int parentalId);

  /// Get a specific parental relationship by its ID
  /// Returns [Parental] if found, null otherwise
  Future<Parental?> getParental(int id);

  /// Add a new parental relationship
  /// Creates a new relationship between parent (user_id) and child (parental_id)
  Future<void> addParental(Parental parental, int userId);

  /// Update an existing parental relationship
  /// Updates the parental relationship with new data
  Future<void> updateParental(Parental parental);

  /// Delete a parental relationship by ID
  /// Removes the relationship from local storage
  Future<void> deleteParental(int id);

  /// Delete all parental relationships
  /// Clears all parental data from local storage
  Future<void> deleteAllParentals();

  /// Check if a parental relationship exists between two users
  /// Returns true if relationship exists, false otherwise
  Future<bool> parentalExists(int parentalId);

  /// Get a parental relationship by user and parental IDs
  /// Returns [Parental] if relationship exists, null otherwise
  Future<Parental?> getParentalByIds(int userId, int parentalId);

  /// Check if a parental record exists by its server ID
  /// Returns true if a record with the given server ID exists
  Future<bool> parentalExistsById(int serverId);
}
