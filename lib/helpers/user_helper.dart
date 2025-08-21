import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class UserHelper {
  /// Gets the current user ID from UserBloc state
  /// Returns null if no user is logged in
  static int? getUserId(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is CurrentUser) {
      return userState.user.userId;
    } else if (userState is UserLoaded) {
      return userState.user.userId;
    }

    return null;
  }

  /// Gets the current User object from UserBloc state
  /// Returns null if no user is logged in
  static User? getCurrentUser(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is CurrentUser) {
      return userState.user;
    } else if (userState is UserLoaded) {
      return userState.user;
    }

    return null;
  }

  /// Gets the current user ID and executes a callback with it
  /// Shows error snackbar if no user is logged in
  /// Returns true if user was found and callback was executed, false otherwise
  static bool executeWithUserId(
    BuildContext context,
    Function(int userId) onUserFound, {
    String? errorMessage,
  }) {
    final userId = getUserId(context);

    if (userId != null) {
      onUserFound(userId);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'No user is currently logged in.'),
        ),
      );
      return false;
    }
  }

  /// Gets the current user ID and executes an async callback with it
  /// Shows error snackbar if no user is logged in
  /// Returns true if user was found and callback was executed, false otherwise
  static Future<bool> executeWithUserIdAsync(
    BuildContext context,
    Future<void> Function(int userId) onUserFound, {
    String? errorMessage,
  }) async {
    final userId = getUserId(context);

    if (userId != null) {
      await onUserFound(userId);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'No user is currently logged in.'),
        ),
      );
      return false;
    }
  }

  /// Gets the current User object and executes a callback with it
  /// Shows error snackbar if no user is logged in
  /// Returns true if user was found and callback was executed, false otherwise
  static bool executeWithUser(
    BuildContext context,
    Function(User user) onUserFound, {
    String? errorMessage,
  }) {
    final user = getCurrentUser(context);

    if (user != null) {
      onUserFound(user);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'No user is currently logged in.'),
        ),
      );
      return false;
    }
  }

  /// Gets the current User object and executes an async callback with it
  /// Shows error snackbar if no user is logged in
  /// Returns true if user was found and callback was executed, false otherwise
  static Future<bool> executeWithUserAsync(
    BuildContext context,
    Future<void> Function(User user) onUserFound, {
    String? errorMessage,
  }) async {
    final user = getCurrentUser(context);

    if (user != null) {
      await onUserFound(user);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'No user is currently logged in.'),
        ),
      );
      return false;
    }
  }

  /// Checks if a user is currently logged in
  static bool isUserLoggedIn(BuildContext context) {
    return getUserId(context) != null;
  }
}
