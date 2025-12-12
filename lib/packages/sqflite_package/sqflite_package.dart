import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';

class SqflitePackage {
  static Database? _db;

  // 💡 Singleton pattern: only one database instance in whole app
  static Future<Database> get instance async {
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
      onOpen: (db) async {},
    );
  }

  // 🏗 Define your tables here
  static Future<void> _createTables(Database db, int version) async {
    await db.execute(createItemsTable);
    await db.execute(createProductsTable);
    await db.execute(createProductDetailsTable);
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
    final db = await instance;
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
    final db = await instance;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final db = await instance;
    return await db.rawQuery(query);
  }

  /// Update any row
  Future<int> update({
    required String table,
    required int id,
    required Map<String, dynamic> data,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await instance;
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
    final db = await instance;
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
    final db = await instance;

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
    final db = await instance;

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

  /// Backup Function
  Future<bool> backupDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, dbName);
      final backupPath = join(dir.path, dbBackupName);

      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.copy(backupPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, dbName);
      final backupPath = join(dir.path, dbBackupName);

      final backupFile = File(backupPath);

      if (await backupFile.exists()) {
        // Close DB first if opened
        await _db?.close();
        _db = null;

        // Replace DB file
        await backupFile.copy(dbPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// ♻ Reset (Delete) the entire database and recreate it
  static Future<void> resetDatabase() async {
    try {
      // 1) Close your in-memory DB reference if open
      if (_db != null) {
        try {
          await _db!.close();
        } catch (e) {
          // ignore or log
        }
        _db = null;
      }

      // 2) Use sqflite's default DB folder (more reliable than applicationDocumentsDirectory)
      final databasesPath = await getDatabasesPath();
      final dbPath = join(databasesPath, dbName);

      // 3) Ensure file exists then delete main DB and WAL/SHM files
      final mainFile = File(dbPath);
      final walFile = File('$dbPath-wal');
      final shmFile = File('$dbPath-shm');

      if (await mainFile.exists()) {
        await deleteDatabase(dbPath); // preferred sqflite helper
      } else {}

      // delete wal and shm if present
      if (await walFile.exists()) {
        try {
          await walFile.delete();
        } catch (_) {}
      }
      if (await shmFile.exists()) {
        try {
          await shmFile.delete();
        } catch (_) {}
      }

      // 4) Final existence check
      // final existsNow = await mainFile.exists();
      // print('DB exists after delete? $existsNow');
    } catch (e) {
      // print('resetDatabase failed: $e\n$st');
      rethrow;
    }
  }
}
