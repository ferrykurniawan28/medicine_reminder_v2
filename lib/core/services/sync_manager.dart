import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/reminder/data/models/reminder_model.dart';
// Import other models and repositories as needed

/// A simple sync manager for offline-first apps.
class SyncManager {
  final Database db;
  final Connectivity connectivity;
  final StreamController<bool> _syncingController =
      StreamController.broadcast();
  bool _isSyncing = false;

  SyncManager({required this.db, required this.connectivity});

  Stream<bool> get syncing => _syncingController.stream;

  Future<void> start() async {
    connectivity.onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        await syncAll();
      }
    });
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _syncingController.add(true);
    try {
      // 1. Push local changes to server (implement per feature)
      await _syncReminders();
      // await _syncAppointments();
      // await _syncUsers();
      // ...
      // 2. Pull latest from server and update local DB (implement per feature)
      // await _pullReminders();
      // ...
    } finally {
      _isSyncing = false;
      _syncingController.add(false);
    }
  }

  Future<void> _syncReminders() async {
    // Example: get unsynced reminders from local DB
    final List<Map<String, dynamic>> unsynced = await db.query(
      'reminders',
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    for (final map in unsynced) {
      final reminder = ReminderModel.fromJson(map);
      // TODO: Push to API, mark as synced if successful
    }
  }

  // Add similar methods for appointments, users, etc.

  void dispose() {
    _syncingController.close();
  }
}

// Usage (in main or a Bloc):
// final syncManager = SyncManager(db: yourDb, connectivity: Connectivity());
// syncManager.start();
