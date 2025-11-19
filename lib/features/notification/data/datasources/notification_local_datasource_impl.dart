import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:medicine_reminder/features/notification/data/models/notification_model.dart';
import 'package:medicine_reminder/features/notification/data/datasources/notification_local_datasource.dart';

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        read_at TEXT,
        data TEXT
      )
    ''');

    // Create index for faster queries
    await db.execute('''
      CREATE INDEX idx_user_id ON notifications(user_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_is_read ON notifications(is_read)
    ''');
  }

  @override
  Future<List<NotificationModel>> getNotifications(int userId) async {
    final db = await database;
    final maps = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToNotificationModel(map)).toList();
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications(int userId) async {
    final db = await database;
    final maps = await db.query(
      'notifications',
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToNotificationModel(map)).toList();
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      _notificationToMap(notification),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final db = await database;
    final batch = db.batch();

    for (final notification in notifications) {
      batch.insert(
        'notifications',
        _notificationToMap(notification),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateNotification(NotificationModel notification) async {
    final db = await database;
    await db.update(
      'notifications',
      _notificationToMap(notification),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final db = await database;
    await db.update(
      'notifications',
      {
        'is_read': 1,
        'read_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  @override
  Future<void> markAllAsRead(int userId) async {
    final db = await database;
    await db.update(
      'notifications',
      {
        'is_read': 1,
        'read_at': DateTime.now().toIso8601String(),
      },
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  @override
  Future<void> clearAllNotifications(int userId) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<bool> notificationExists(String notificationId) async {
    final db = await database;
    final result = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [notificationId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Helper methods to convert between Map and NotificationModel
  Map<String, dynamic> _notificationToMap(NotificationModel notification) {
    return {
      'id': notification.id,
      'user_id': notification.userId,
      'title': notification.title,
      'message': notification.message,
      'type': notification.type.key,
      'created_at': notification.createdAt.toIso8601String(),
      'is_read': notification.isRead ? 1 : 0,
      'read_at': notification.readAt?.toIso8601String(),
      'data': notification.data != null ? _encodeMap(notification.data!) : null,
    };
  }

  NotificationModel _mapToNotificationModel(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      message: map['message'] as String,
      type: NotificationTypeExtension.fromString(map['type'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      isRead: (map['is_read'] as int) == 1,
      readAt: map['read_at'] != null
          ? DateTime.parse(map['read_at'] as String)
          : null,
      data: map['data'] != null ? _decodeMap(map['data'] as String) : null,
    );
  }

  // JSON encoding for data field
  String _encodeMap(Map<String, dynamic> map) {
    return jsonEncode(map);
  }

  Map<String, dynamic> _decodeMap(String encoded) {
    if (encoded.isEmpty) return {};
    return jsonDecode(encoded) as Map<String, dynamic>;
  }
}
