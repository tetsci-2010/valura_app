import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';

class SqflitePackage {
  static Database? _db;

  // 💡 Singleton pattern: only one database instance in whole app
  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  // 📍 Create the database file
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // 🗂 where databases are saved
    final path = join(dbPath, dbName); // 📌 our custom file name

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables, // 🔥 Runs the first time DB is created
    );
  }

  // 🏗 Define your tables here
  static Future<void> _createTables(Database db, int version) async {
    await db.execute(createItemsTable);
  }

  /* =========================
        🔹 Universal CRUD 🔹
     ========================= */

  /// Insert into any table
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: conflictAlgorithm);
  }

  /// Read rows with optional filtering | ordering
  Future<List<Map<String, dynamic>>> query({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  /// Update any row
  Future<int> update({
    required String table,
    required int id,
    required Map<String, dynamic> data,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Delete any row
  Future<int> delete({required String table, int? id}) async {
    final db = await database;
    if (id != null) {
      return await db.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
    } else {
      return await db.delete(table);
    }
  }

  /// 🔍 Query with multiple conditions dynamically
  Future<List<Map<String, dynamic>>> queryWhere({
    required String table,
    required Map<String, dynamic> conditions,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;

    // Build condition string:  col1 = ? AND col2 = ? ...
    final whereClause = conditions.keys.map((key) => "$key = ?").join(" AND ");

    // Convert values to whereArgs
    final whereValues = conditions.values.toList();

    return await db.query(
      table,
      where: whereClause,
      whereArgs: whereValues,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<Map<String, dynamic>> getLastRow(String table) async {
    final db = await database;

    final result = await db.query(
      table,
      orderBy: "id DESC",
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return {};
  }

  /// ♻ Reset (Delete) the entire database and recreate it
  static Future<void> resetDatabase() async {
    // Close DB if open
    if (_db != null) {
      await _db!.close();
      _db = null;
    }

    // Find DB file path
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, dbName);

    // Delete DB file
    await deleteDatabase(dbPath);
  }
}
