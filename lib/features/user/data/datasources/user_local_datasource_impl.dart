import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user.dart';
import 'user_local_datasource.dart';

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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            username TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<User>> getUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User?> getUser(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return User.fromJson(maps.first);
  }

  @override
  Future<void> addUser(User user) async {
    final db = await database;
    final data = user.toJson();
    if (data['id'] == null) {
      data.remove('id');
    }
    await db.insert('users', data);
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', user.toJson(),
        where: 'id = ?', whereArgs: [user.userId]);
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
