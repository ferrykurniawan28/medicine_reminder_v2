// import 'package:medicine_reminder/features/parental/data/services/parental_service.dart';
// import 'package:medicine_reminder/helpers/user_helper.dart';
// import 'package:flutter/material.dart';

// // Export the ParentalRelationship class for external use
// export 'package:medicine_reminder/features/parental/data/services/parental_service.dart'
//     show ParentalRelationship;

// class ParentalHelper {
//   static final ParentalService _service = ParentalService();

//   /// Add a parental relationship
//   /// [context] - BuildContext for getting current user
//   /// [parentalId] - ID of the parent/guardian user
//   /// Returns true if successful, false otherwise
//   static Future<bool> addParentalRelationship(
//       BuildContext context, int parentalId) async {
//     final userId = UserHelper.getUserId(context);
//     if (userId == null) return false;

//     return await _service.addParentalRelationship(userId, parentalId);
//   }

//   /// Get all parental relationships for current user
//   /// Returns list of ParentalRelationship objects with parent user info
//   static Future<List<ParentalRelationship>> getMyParentals(
//       BuildContext context) async {
//     final userId = UserHelper.getUserId(context);
//     if (userId == null) return [];

//     return await _service.getParentalsForUser(userId);
//   }

//   /// Get all users managed by current user (if current user is a parent)
//   /// Returns list of ParentalRelationship objects with managed user info
//   static Future<List<ParentalRelationship>> getManagedUsers(
//       BuildContext context) async {
//     final userId = UserHelper.getUserId(context);
//     if (userId == null) return [];

//     return await _service.getUsersForParental(userId);
//   }

//   /// Check if current user has a specific parental relationship
//   static Future<bool> hasParentalRelationship(
//       BuildContext context, int parentalId) async {
//     final userId = UserHelper.getUserId(context);
//     if (userId == null) return false;

//     return await _service.relationshipExists(userId, parentalId);
//   }

//   /// Remove a parental relationship by relationship ID
//   static Future<bool> removeParentalRelationship(int relationshipId) async {
//     return await _service.removeParentalRelationship(relationshipId);
//   }

//   /// Remove parental relationship between current user and specific parental
//   static Future<bool> removeMyParentalRelationship(
//       BuildContext context, int parentalId) async {
//     final userId = UserHelper.getUserId(context);
//     if (userId == null) return false;

//     return await _service.removeRelationshipByIds(userId, parentalId);
//   }

//   /// Execute a function with current user's parental relationships
//   /// Shows error snackbar if no user is logged in
//   static Future<void> executeWithParentals(
//     BuildContext context,
//     Function(List<ParentalRelationship> parentals) onSuccess, {
//     String? errorMessage,
//   }) async {
//     final parentals = await getMyParentals(context);
//     if (parentals.isNotEmpty) {
//       onSuccess(parentals);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage ?? 'No parental relationships found.'),
//         ),
//       );
//     }
//   }

//   /// Execute a function with users managed by current user
//   /// Shows error snackbar if no user is logged in or no managed users
//   static Future<void> executeWithManagedUsers(
//     BuildContext context,
//     Function(List<ParentalRelationship> managedUsers) onSuccess, {
//     String? errorMessage,
//   }) async {
//     final managedUsers = await getManagedUsers(context);
//     if (managedUsers.isNotEmpty) {
//       onSuccess(managedUsers);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage ?? 'No managed users found.'),
//         ),
//       );
//     }
//   }

//   /// Check if current user is a parent (has managed users)
//   static Future<bool> isParent(BuildContext context) async {
//     final managedUsers = await getManagedUsers(context);
//     return managedUsers.isNotEmpty;
//   }

//   /// Check if current user has parents (is managed by someone)
//   static Future<bool> hasParents(BuildContext context) async {
//     final parentals = await getMyParentals(context);
//     return parentals.isNotEmpty;
//   }

//   /// Get all relationships (for admin/debugging purposes)
//   static Future<List<ParentalRelationship>> getAllRelationships() async {
//     return await _service.getAllRelationships();
//   }
// }
