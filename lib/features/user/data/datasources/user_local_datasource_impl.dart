import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user.dart';
import 'user_local_datasource.dart';
import '../../data/models/user_model.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    return await openDatabase(
      path,
      version: 2, // Bump version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            username TEXT,
            email TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE users ADD COLUMN is_synced INTEGER DEFAULT 0');
        }
      },
    );
  }

  @override
  Future<List<User>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<User?> getUser(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return UserModel.fromJson(maps.first);
  }

  @override
  Future<void> addUser(User user) async {
    final db = await database;
    final userModel = user is UserModel
        ? user
        : UserModel(
            userId: user.userId, userName: user.userName, email: user.email);
    final data = userModel.toJson();
    data['is_synced'] = 0; // Always mark as not synced on local add
    await db.insert('users', data);
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await database;
    final userModel = user is UserModel
        ? user
        : UserModel(
            userId: user.userId, userName: user.userName, email: user.email);
    final data = userModel.toJson();
    data['is_synced'] = 0; // Always mark as not synced on local update
    await db.update('users', data, where: 'id = ?', whereArgs: [user.userId]);
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
}
