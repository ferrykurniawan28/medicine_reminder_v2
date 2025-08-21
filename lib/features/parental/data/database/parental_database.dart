import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ParentalDatabase {
  static Database? _database;
  static const String tableName = 'parental_relationships';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parental.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            parental_id INTEGER NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(user_id, parental_id)
          )
        ''');

        // Create indexes for better performance
        await db.execute('CREATE INDEX idx_user_id ON $tableName(user_id)');
        await db
            .execute('CREATE INDEX idx_parental_id ON $tableName(parental_id)');
      },
    );
  }

  // Add a parental relationship
  Future<int> addParentalRelationship(int userId, int parentalId) async {
    final db = await database;
    return await db.insert(
      tableName,
      {
        'user_id': userId,
        'parental_id': parentalId,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Get all parental relationships for a user
  Future<List<Map<String, dynamic>>> getParentalsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Get all users managed by a parental
  Future<List<Map<String, dynamic>>> getUsersByParentalId(
      int parentalId) async {
    final db = await database;
    return await db.query(
      tableName,
      where: 'parental_id = ?',
      whereArgs: [parentalId],
      orderBy: 'created_at DESC',
    );
  }

  // Get parental relationships with user info (requires user database connection)
  Future<List<Map<String, dynamic>>> getParentalsWithUserInfo(
      int userId) async {
    final db = await database;

    // Join with users table to get user information
    final result = await db.rawQuery('''
      SELECT 
        p.id,
        p.user_id,
        p.parental_id,
        p.created_at,
        u.id as parent_user_id,
        u.username as parent_username,
        u.email as parent_email
      FROM $tableName p
      LEFT JOIN users u ON p.parental_id = u.id
      WHERE p.user_id = ?
      ORDER BY p.created_at DESC
    ''', [userId]);

    return result;
  }

  // Get users managed by parental with user info
  Future<List<Map<String, dynamic>>> getUsersWithInfoByParentalId(
      int parentalId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT 
        p.id,
        p.user_id,
        p.parental_id,
        p.created_at,
        u.id as managed_user_id,
        u.username as managed_username,
        u.email as managed_email
      FROM $tableName p
      LEFT JOIN users u ON p.user_id = u.id
      WHERE p.parental_id = ?
      ORDER BY p.created_at DESC
    ''', [parentalId]);

    return result;
  }

  // Check if parental relationship exists
  Future<bool> relationshipExists(int userId, int parentalId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'user_id = ? AND parental_id = ?',
      whereArgs: [userId, parentalId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Remove parental relationship
  Future<int> removeParentalRelationship(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Remove relationship by user and parental IDs
  Future<int> removeRelationshipByIds(int userId, int parentalId) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'user_id = ? AND parental_id = ?',
      whereArgs: [userId, parentalId],
    );
  }

  // Get all relationships
  Future<List<Map<String, dynamic>>> getAllRelationships() async {
    final db = await database;
    return await db.query(tableName, orderBy: 'created_at DESC');
  }

  // Clear all relationships (for testing/reset)
  Future<int> clearAllRelationships() async {
    final db = await database;
    return await db.delete(tableName);
  }
}
