import '../database/parental_database.dart';
import '../../../user/domain/entities/user.dart';

class ParentalService {
  final ParentalDatabase _parentalDatabase = ParentalDatabase();

  // Add a parental relationship
  Future<bool> addParentalRelationship(int userId, int parentalId) async {
    try {
      // Check if relationship already exists
      final exists =
          await _parentalDatabase.relationshipExists(userId, parentalId);
      if (exists) {
        return false; // Relationship already exists
      }

      final result =
          await _parentalDatabase.addParentalRelationship(userId, parentalId);
      return result > 0;
    } catch (e) {
      print('Error adding parental relationship: $e');
      return false;
    }
  }

  // Get all parental relationships for a user with user info
  Future<List<ParentalRelationship>> getParentalsForUser(int userId) async {
    try {
      final relationships =
          await _parentalDatabase.getParentalsWithUserInfo(userId);

      List<ParentalRelationship> result = [];
      for (var rel in relationships) {
        User? parentUser;
        if (rel['parent_user_id'] != null) {
          parentUser = User(
            userId: rel['parent_user_id'],
            userName: rel['parent_username'],
            email: rel['parent_email'],
          );
        }

        result.add(ParentalRelationship(
          id: rel['id'],
          userId: rel['user_id'],
          parentalId: rel['parental_id'],
          createdAt: DateTime.parse(rel['created_at']),
          parentUser: parentUser,
        ));
      }

      return result;
    } catch (e) {
      print('Error getting parentals for user: $e');
      return [];
    }
  }

  // Get all users managed by a parental with user info
  Future<List<ParentalRelationship>> getUsersForParental(int parentalId) async {
    try {
      final relationships =
          await _parentalDatabase.getUsersWithInfoByParentalId(parentalId);

      List<ParentalRelationship> result = [];
      for (var rel in relationships) {
        User? managedUser;
        if (rel['managed_user_id'] != null) {
          managedUser = User(
            userId: rel['managed_user_id'],
            userName: rel['managed_username'],
            email: rel['managed_email'],
          );
        }

        result.add(ParentalRelationship(
          id: rel['id'],
          userId: rel['user_id'],
          parentalId: rel['parental_id'],
          createdAt: DateTime.parse(rel['created_at']),
          managedUser: managedUser,
        ));
      }

      return result;
    } catch (e) {
      print('Error getting users for parental: $e');
      return [];
    }
  }

  // Check if relationship exists
  Future<bool> relationshipExists(int userId, int parentalId) async {
    try {
      return await _parentalDatabase.relationshipExists(userId, parentalId);
    } catch (e) {
      print('Error checking relationship: $e');
      return false;
    }
  }

  // Remove parental relationship
  Future<bool> removeParentalRelationship(int relationshipId) async {
    try {
      final result =
          await _parentalDatabase.removeParentalRelationship(relationshipId);
      return result > 0;
    } catch (e) {
      print('Error removing parental relationship: $e');
      return false;
    }
  }

  // Remove relationship by user and parental IDs
  Future<bool> removeRelationshipByIds(int userId, int parentalId) async {
    try {
      final result =
          await _parentalDatabase.removeRelationshipByIds(userId, parentalId);
      return result > 0;
    } catch (e) {
      print('Error removing relationship by IDs: $e');
      return false;
    }
  }

  // Get all relationships (for admin/debugging)
  Future<List<ParentalRelationship>> getAllRelationships() async {
    try {
      final relationships = await _parentalDatabase.getAllRelationships();

      return relationships
          .map((rel) => ParentalRelationship(
                id: rel['id'],
                userId: rel['user_id'],
                parentalId: rel['parental_id'],
                createdAt: DateTime.parse(rel['created_at']),
              ))
          .toList();
    } catch (e) {
      print('Error getting all relationships: $e');
      return [];
    }
  }
}

// Data model for parental relationships
class ParentalRelationship {
  final int id;
  final int userId;
  final int parentalId;
  final DateTime createdAt;
  final User? parentUser; // For when viewing from user perspective
  final User? managedUser; // For when viewing from parental perspective

  ParentalRelationship({
    required this.id,
    required this.userId,
    required this.parentalId,
    required this.createdAt,
    this.parentUser,
    this.managedUser,
  });

  @override
  String toString() {
    return 'ParentalRelationship(id: $id, userId: $userId, parentalId: $parentalId, createdAt: $createdAt)';
  }
}
