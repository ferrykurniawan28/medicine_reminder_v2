import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/parental.dart';
import '../models/parental_model.dart';
import 'parental_local_datasource.dart';
import '../../../user/data/models/user_model.dart';

class ParentalLocalDataSourceImpl implements ParentalLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parental.db'); // Use separate parental database
    return await openDatabase(
      path,
      version: 3, // Bump version to force recreation
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop and recreate table to ensure clean state
        await db.execute('DROP TABLE IF EXISTS parental');
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Create parental table only
    await db.execute('''
      CREATE TABLE parental(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        parental_id INTEGER NOT NULL,
        created_at TEXT,
        is_deleted INTEGER DEFAULT 0,
        UNIQUE(user_id, parental_id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_parental_user_id ON parental(user_id)');
    await db.execute(
        'CREATE INDEX idx_parental_parental_id ON parental(parental_id)');
    await db.execute(
        'CREATE INDEX idx_parental_is_deleted ON parental(is_deleted)');
  }

  /// Ensure the table exists before performing operations
  Future<void> _ensureTableExists() async {
    final db = await database;
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='parental'");

    if (tables.isEmpty) {
      print('Parental table not found, creating it...');
      await _createTables(db);
    }
  }

  @override
  Future<List<Parental>> getParentals(int userId) async {
    final db = await database;

    // Query parental table only (no join since users are in separate database)
    // Only return non-deleted records
    final maps = await db.query(
      'parental',
      where: '(user_id = ? OR parental_id = ?) AND is_deleted = ?',
      whereArgs: [userId, userId, 0],
      orderBy: 'created_at DESC',
    );

    // Map each result with real user data
    final List<Parental> parentals = [];
    for (final map in maps) {
      final parental = await _mapToParental(map);
      parentals.add(parental);
    }

    return parentals;
  }

  @override
  Future<List<Parental>> getParentalsByParentalId(int parentalId) async {
    final db = await database;

    // Query parental table only (no join since users are in separate database)
    // Only return non-deleted records
    final maps = await db.query(
      'parental',
      where: 'parental_id = ? AND is_deleted = ?',
      whereArgs: [parentalId, 0],
      orderBy: 'created_at DESC',
    );

    // Map each result with real user data
    final List<Parental> parentals = [];
    for (final map in maps) {
      final parental = await _mapToParental(map);
      parentals.add(parental);
    }

    return parentals;
  }

  @override
  Future<Parental?> getParental(int id) async {
    final db = await database;

    // Only return non-deleted records
    final maps = await db.query(
      'parental',
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [id, 0],
    );

    if (maps.isEmpty) return null;
    return _mapToParental(maps.first);
  }

  @override
  Future<void> addParental(Parental parental, int userId) async {
    await _ensureTableExists(); // Ensure table exists before operation
    final db = await database;
    final parentalModel = ParentalModel.fromEntity(parental);

    final now = DateTime.now();
    final dataToInsert = parentalModel.toJsonForInsert();
    dataToInsert['created_at'] = now.toIso8601String();
    dataToInsert['user_id'] = userId; // Ensure user_id is set

    print('Inserting parental relationship: $dataToInsert');

    await db.insert(
      'parental',
      dataToInsert,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<void> updateParental(Parental parental) async {
    final db = await database;
    final parentalModel = ParentalModel.fromEntity(parental);

    await db.update(
      'parental',
      parentalModel.toJson(),
      where: 'id = ?',
      whereArgs: [parental.id],
    );
  }

  @override
  Future<void> deleteParental(int id) async {
    final db = await database;
    // Soft delete: mark as deleted instead of actual deletion
    await db.update(
      'parental',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllParentals() async {
    final db = await database;
    // Soft delete: mark all as deleted instead of actual deletion
    await db.update('parental', {'is_deleted': 1});
  }

  // Helper method to map database result to Parental (with real user data)
  Future<ParentalModel> _mapToParental(Map<String, dynamic> map) async {
    // Get real user data from users database
    final user = await _getUserById(map['parental_id'] as int);

    return ParentalModel(
      id: map['id'] as int?,
      user: user,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
    );
  }

  // Helper method to fetch user data from users database
  Future<UserModel> _getUserById(int userId) async {
    try {
      // Connect to the users database
      final dbPath = await getDatabasesPath();
      final usersDbPath = join(dbPath, 'users.db');
      final usersDb = await openDatabase(usersDbPath);

      final userMaps = await usersDb.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      await usersDb.close();

      if (userMaps.isNotEmpty) {
        final userData = userMaps.first;
        print('Found user data: $userData'); // Debug log
        return UserModel.fromJson(userData);
      } else {
        print('No user found with id: $userId'); // Debug log
      }
    } catch (e) {
      // If user database query fails, return placeholder
      print('Error fetching user $userId: $e');
    }

    // Fallback to placeholder user if not found or error occurs
    print('Using placeholder for user $userId'); // Debug log
    return UserModel(
      userId: userId,
      userName: 'User $userId',
      email: '',
    );
  }

  // Method to check if parental relationship exists
  @override
  Future<bool> parentalExists(int parentalId) async {
    final db = await database;
    final result = await db.query(
      'parental',
      where: 'parental_id = ? AND is_deleted = ?',
      whereArgs: [parentalId, 0],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Method to get parental relationship by user and parental IDs
  @override
  Future<Parental?> getParentalByIds(int userId, int parentalId) async {
    final db = await database;
    final maps = await db.query(
      'parental',
      where: 'user_id = ? AND parental_id = ? AND is_deleted = ?',
      whereArgs: [userId, parentalId, 0],
    );

    if (maps.isEmpty) return null;
    return _mapToParental(maps.first);
  }

  // Method to check if parental record exists by server ID
  @override
  Future<bool> parentalExistsById(int serverId) async {
    final db = await database;
    final result = await db.query(
      'parental',
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [serverId, 0],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
