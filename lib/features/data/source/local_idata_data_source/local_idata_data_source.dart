import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/backup_model.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/helpers/file_size_helper.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';
import 'package:path/path.dart' as p;
import 'package:valura/utils/dependency_injection.dart';

abstract class ILocalDataDataSource {
  Future<String> storeItem(ItemModel itemModel);
  Future<String> storeProduct(ProductFormModel product);
  Future<List<ProductModel>> fetchProducts({Sort? sort});
  Future<String> deleteProduct(int? id);
  Future<List<ItemModel>> fetchProductDetails(int id);
  Future<ItemModel?> editProductDetails(int id);
  Future<String> deleteProductDetail({required int id, required int pId});
  Future<String> updateProductDetail({required ItemModel item, required int pId});
  Future<String> backupDB();
  Future<List<BackupModel>> fetchBackups();
  Future<String> deleteBackup(String path);
  Future<String> restoreBackup();
  Future<List<ItemModel>> fetchItems(Sort? sort);
  Future<String> deleteItem(int? id);
  Future<ItemModel> editItem(int id);
  Future<String> updateItem(ItemModel item);
}

class LocalDataDataSourceImp implements ILocalDataDataSource {
  @override
  Future<String> storeItem(ItemModel itemModel) async {
    try {
      SqflitePackage db = SqflitePackage();
      Map<String, dynamic> item = await db.getLastRow(itemsTable);
      int index = 0;
      if (item.isNotEmpty) {
        index = item['id'] + 1;
      }
      await db.insert(
        table: itemsTable,
        data: {
          'id': index,
          'item_id': index,
          'name': itemModel.name,
          'purchase_rate': itemModel.purchaseRate,
          'land_cost': itemModel.landCost,
          'unit_cost': itemModel.unitCost,
          'new_rate': itemModel.newRate,
          'description': itemModel.description,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> storeProduct(ProductFormModel product) async {
    try {
      await (await SqflitePackage.instance).transaction(
        (txn) async {
          final last = await txn.rawQuery('SELECT id FROM $productsTable ORDER BY id DESC LIMIT 1');

          int itemId = last.isNotEmpty ? (last.first['id'] as int) + 1 : 1;
          int index = await txn.insert(
            productsTable,
            {
              'name': '${product.name} $itemId',
              'total': product.total,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          for (var i = 0; i < product.names.length; i++) {
            await txn.insert(
              productDetailsTable,
              {
                'product_id': index,
                'item_id': product.itemIds[i],
                'name': product.names[i],
                'purchase_rate': product.purchaseRates[i],
                'land_cost': product.landCosts[i],
                'unit_cost': product.costs[i],
                'new_rate': product.newRates[i],
                'description': product.descriptions[i],
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          di<AppProvider>().clearDropDownItems();
        },
      );
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts({Sort? sort}) async {
    try {
      SqflitePackage db = SqflitePackage();
      String sortt = sort?.getName ?? Sort.descending.getName;
      List<Map<String, dynamic>> products = await db.rawQuery('SELECT * FROM $productsTable ORDER BY id $sortt');
      List<ProductModel> pProducts = [];
      for (var product in products) {
        List<Map<String, dynamic>> items = await db.query(
          table: productDetailsTable,
          where: 'product_id = ?',
          whereArgs: [product['id']],
        );
        List<ItemModel> pItems = items.map((e) => ItemModel.fromDB(e)).toList();
        // items.forEach((element) => print(element));
        // return [];
        pProducts.add(
          ProductModel(id: product['id'], name: product['name'], total: product['total'], items: pItems),
        );
      }
      return pProducts;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> deleteProduct(int? id) async {
    try {
      if (id != null) {
        await (await SqflitePackage.instance).transaction((txn) async {
          await txn.delete(productDetailsTable, where: 'product_id = ?', whereArgs: [id]);
          await txn.delete(productsTable, where: 'id = ?', whereArgs: [id]);
        });
      } else {
        await (await SqflitePackage.instance).transaction((txn) async {
          await txn.delete(productDetailsTable);
          await txn.delete(productsTable);
        });
      }

      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<List<ItemModel>> fetchProductDetails(int id) async {
    try {
      SqflitePackage db = SqflitePackage();
      List<Map<String, dynamic>> items = await db.query(table: productDetailsTable, where: 'product_id = ?', whereArgs: [id]);
      List<ItemModel> pItems = items.map((e) => ItemModel.fromDB(e)).toList();
      return pItems;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<ItemModel?> editProductDetails(int id) async {
    try {
      SqflitePackage db = SqflitePackage();
      List<Map<String, dynamic>> details = await db.query(table: productDetailsTable, where: 'id = ?', whereArgs: [id]);
      if (details.isEmpty) return null;
      ItemModel detail = ItemModel.fromDB(details.first);
      return detail;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> deleteProductDetail({required int id, required int pId}) async {
    try {
      num count = 0;
      await (await SqflitePackage.instance).transaction((txn) async {
        await txn.delete(
          productDetailsTable,
          where: 'id = ?',
          whereArgs: [id],
        );

        final remaining = await txn.rawQuery(
          'SELECT COUNT(*) AS count FROM $productDetailsTable WHERE product_id = ?',
          [pId],
        );

        count = Sqflite.firstIntValue(remaining) ?? 0;
      });
      if (count == 0) {
        return SqfliteCodes.successCodeWithDelete;
      }
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> updateProductDetail({required ItemModel item, required int pId}) async {
    try {
      await (await SqflitePackage.instance).transaction((txn) async {
        await txn.delete(productDetailsTable, where: 'id = ? AND product_id = ?', whereArgs: [item.id, pId]);
        await txn.insert(
          productDetailsTable,
          {
            'id': item.id,
            'product_id': pId,
            'item_id': item.itemId,
            'name': item.name,
            'purchase_rate': item.purchaseRate,
            'land_cost': item.landCost,
            'unit_cost': item.unitCost,
            'new_rate': item.newRate,
            'description': item.description,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> backupDB() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, dbName);
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('Database file not found');
      }

      // ✔ Safe filename
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');

      final backupFileName = 'valura_backup_$timestamp.db';

      // ✅ REAL public Downloads folder
      final downloadsDir = Directory('/storage/emulated/0/Download');

      final backupFolder = Directory(
        join(downloadsDir.path, 'ValuraBackups'),
      );

      if (!await backupFolder.exists()) {
        await backupFolder.create(recursive: true);
      }

      final backupPath = join(backupFolder.path, backupFileName);
      await dbFile.copy(backupPath);

      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException('Unexpected error during backup: ${e.toString()}', '500');
    }
  }

  @override
  Future<List<BackupModel>> fetchBackups() async {
    try {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) return [];
      final backupDir = Directory(p.join(downloadsDir.path, dbFolder));
      if (!await backupDir.exists()) {
        //* Backup directory does not exist: ${backupDir.path}
        return [];
      }

      //* List all files in directory
      final List<FileSystemEntity> files = await backupDir.list().toList();
      List<Map<String, dynamic>> backups = [];
      for (final file in files) {
        if (file is File) {
          try {
            final stat = await file.stat();

            //* Get file extension and check if it's a backup file
            final fileName = p.basename(file.path);
            // final fileExtension = p.extension(fileName).toLowerCase();

            //* You can filter by specific extensions if needed
            //* For example: .json, .db, .backup, .valura
            //* For now, include all files in the backup folder
            //* if (fileExtension == '.json' || fileExtension == '.db') {

            backups.add({
              'name': fileName,
              'size': FileSizeHelper.formatFileSize(stat.size), // in bytes
              'path': file.path,
              'lastModified': stat.modified.millisecondsSinceEpoch,
            });
          } on AppException catch (_) {
            rethrow;
          } catch (e) {
            //* Error reading file ${file.path}
            throw AppException(e.toString());
          }
        }
      }

      //* Sort by last modified (newest first)
      backups.sort((a, b) => b['lastModified'].compareTo(a['lastModified']));
      if (backups.isEmpty) return [];
      List<BackupModel> pBackups = backups.map((e) => BackupModel.fromDB(e)).toList();
      return pBackups;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> deleteBackup(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        throw AppException(SqfliteCodes.fileNotFoundToDelete);
      }
      await file.delete();
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> restoreBackup() async {
    try {
      // 1️⃣ Pick .db file using SAF
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
        withData: false,
      );

      if (result == null || result.files.single.path == null) {
        throw AppException(SqfliteCodes.noFileSelected);
      }

      final pickedFile = File(result.files.single.path!);

      if (!await pickedFile.exists()) {
        throw AppException(SqfliteCodes.fileNoFound);
      }

      // 2️⃣ Close database BEFORE touching files
      final dbInstance = await SqflitePackage.instance;
      if (dbInstance.isOpen) {
        await dbInstance.close();
      }
      SqflitePackage.resetDB();
      // 3️⃣ REAL app database path
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(appDir.path, dbName);
      final dbFile = File(dbPath);

      // 4️⃣ Remove old database
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      // 5️⃣ Restore backup → active DB
      await pickedFile.copy(dbPath);
      await SqflitePackage.instance;

      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<List<ItemModel>> fetchItems(Sort? sort) async {
    try {
      SqflitePackage db = SqflitePackage();
      String sortt = sort?.getName ?? Sort.descending.getName;
      List<Map<String, dynamic>> items = await db.rawQuery('SELECT * FROM $itemsTable ORDER BY id $sortt');
      if (items.isEmpty) return [];
      List<ItemModel> pItems = items.map((e) => ItemModel.fromDB(e)).toList();
      return pItems;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> deleteItem(int? id) async {
    try {
      SqflitePackage db = SqflitePackage();
      if (id == null) {
        await db.delete(table: itemsTable);
        return SqfliteCodes.successCode;
      } else {
        await db.delete(table: itemsTable, id: id);
        return SqfliteCodes.successCode;
      }
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<ItemModel> editItem(int id) async {
    try {
      SqflitePackage db = SqflitePackage();
      print(id);
      List<Map<String, dynamic>> items = await db.query(table: itemsTable, where: 'id = ?', whereArgs: [id]);
      if (items.isEmpty) throw AppException(SqfliteCodes.itemNotFound);
      ItemModel item = ItemModel.fromDB(items.first);
      return item;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> updateItem(ItemModel item) async {
    try {
      await (await SqflitePackage.instance).transaction((txn) async {
        await txn.delete(itemsTable, where: 'id = ?', whereArgs: [item.id]);
        await txn.insert(
          itemsTable,
          {
            'id': item.id,
            'item_id': item.id,
            'name': item.name,
            'purchase_rate': item.purchaseRate,
            'land_cost': item.landCost,
            'unit_cost': item.unitCost,
            'new_rate': item.newRate,
            'description': item.description,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(msg, SqfliteCodes.dbOpenFailed);
      } else if (e.isSyntaxError()) {
        throw AppException(msg, SqfliteCodes.sqlSyntaxError);
      } else if (e.isNoSuchTableError()) {
        throw AppException(msg, SqfliteCodes.tableNotFound);
      } else if (e.isDatabaseClosedError()) {
        throw AppException(msg, SqfliteCodes.dbClosed);
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
      } else {
        throw AppException(msg, SqfliteCodes.databaseException);
      }
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }
}


  // Future<String> backupDB() async {
  //   try {
  //     // Request storage permission for Android
  //     if (Platform.isAndroid) {
  //       final status = await Permission.storage.status;
  //       if (!status.isGranted) {
  //         final result = await Permission.storage.request();
  //         if (!result.isGranted) {
  //           print('⚠️ Storage permission denied, saving to app directory only');
  //           // Continue without permission, will save to app directory
  //         }
  //       }
  //     }

  //     // Get app documents directory
  //     final appDir = await getApplicationDocumentsDirectory();

  //     // Original DB path
  //     final dbPath = join(appDir.path, dbName);
  //     final dbFile = File(dbPath);

  //     print('📁 DB Path: $dbPath');
  //     print('📁 DB File exists: ${await dbFile.exists()}');

  //     if (await dbFile.exists()) {
  //       final dbStat = await dbFile.stat();
  //       print('📁 DB File size: ${dbStat.size} bytes');
  //     }

  //     if (!await dbFile.exists()) {
  //       throw AppException('Source database file not found', SqfliteCodes.createBackupFailed);
  //     }

  //     final dbStat = await dbFile.stat();
  //     if (dbStat.size == 0) {
  //       print('⚠️ Source DB file is empty (0 bytes)');
  //     }

  //     // ========== BACKUP TO APP PRIVATE DIRECTORY ==========
  //     final privateBackupPath = join(appDir.path, dbBackupName);
  //     final privateBackupFile = File(privateBackupPath);

  //     // Create backup directory if it doesn't exist
  //     final privateBackupDir = privateBackupFile.parent;
  //     if (!await privateBackupDir.exists()) {
  //       print('📁 Creating private backup directory: ${privateBackupDir.path}');
  //       await privateBackupDir.create(recursive: true);
  //     }

  //     // If private backup exists, delete it
  //     if (await privateBackupFile.exists()) {
  //       print('🗑️ Deleting existing private backup file');
  //       await privateBackupFile.delete();
  //     }

  //     // Copy to private backup location
  //     print('📋 Starting private backup...');
  //     final stopwatch = Stopwatch()..start();
  //     await dbFile.copy(privateBackupPath);
  //     stopwatch.stop();

  //     final privateBackupStat = await privateBackupFile.stat();
  //     print('✅ Private backup completed in ${stopwatch.elapsedMilliseconds}ms');
  //     print('✅ Private backup size: ${privateBackupStat.size} bytes');
  //     print('✅ Private backup path: $privateBackupPath');

  //     // ========== COPY TO PUBLIC STORAGE ==========
  //     String publicBackupPath = '';
  //     File? publicBackupFile;

  //     try {
  //       // Get public storage directory (Downloads folder on Android, Documents on iOS)
  //       Directory? publicDir;

  //       if (Platform.isAndroid) {
  //         // Try to get external storage first (usually internal storage/Downloads)
  //         publicDir = await getExternalStorageDirectory();

  //         if (publicDir == null) {
  //           // Fallback to downloads directory
  //           publicDir = Directory('/storage/emulated/0/Download');
  //           if (!await publicDir.exists()) {
  //             publicDir = await getApplicationDocumentsDirectory();
  //           }
  //         }
  //       } else if (Platform.isIOS) {
  //         // iOS: Save to documents directory (accessible via Files app)
  //         publicDir = await getApplicationDocumentsDirectory();
  //       } else {
  //         // Web/Desktop fallback
  //         publicDir = appDir;
  //       }

  //       // Create timestamp for unique filename
  //       final timestamp = DateTime.now().millisecondsSinceEpoch;
  //       final dateStr = DateTime.now().toString().substring(0, 10).replaceAll('-', '');

  //       // Create public backup path
  //       publicBackupPath = join(publicDir!.path, 'ValuraBackups', 'valura_backup_${dateStr}_$timestamp.db');

  //       publicBackupFile = File(publicBackupPath);

  //       // Create public backup directory if it doesn't exist
  //       final publicBackupDir = publicBackupFile.parent;
  //       if (!await publicBackupDir.exists()) {
  //         print('📁 Creating public backup directory: ${publicBackupDir.path}');
  //         await publicBackupDir.create(recursive: true);
  //       }

  //       // If public backup exists, delete it (shouldn't happen with timestamp)
  //       if (await publicBackupFile.exists()) {
  //         print('🗑️ Deleting existing public backup file');
  //         await publicBackupFile.delete();
  //       }

  //       // Copy to public location
  //       print('📋 Copying to public storage...');
  //       final publicStopwatch = Stopwatch()..start();
  //       await privateBackupFile.copy(publicBackupPath);
  //       publicStopwatch.stop();

  //       final publicBackupStat = await publicBackupFile.stat();
  //       print('✅ Public backup completed in ${publicStopwatch.elapsedMilliseconds}ms');
  //       print('✅ Public backup size: ${publicBackupStat.size} bytes');
  //       print('📍 Public backup location: $publicBackupPath');

  //       // For Android, display the accessible path
  //       if (Platform.isAndroid) {
  //         // Extract user-friendly path
  //         final friendlyPath = publicBackupPath.replaceAll('/storage/emulated/0/', 'Internal Storage/');
  //         print('📱 User accessible path: $friendlyPath');
  //       }
  //     } catch (e) {
  //       // If public backup fails, log but don't fail the entire operation
  //       print('⚠️ Failed to save to public storage: $e');
  //       print('⚠️ Backup saved only to private storage: $privateBackupPath');
  //       // Continue with private backup only
  //     }

  //     // ========== SAVE BACKUP RECORD TO DATABASE ==========
  //     SqflitePackage db = SqflitePackage();
  //     try {
  //       await db.insert(
  //         table: backupsTable,
  //         data: {
  //           'name': dbBackupName,
  //           'path': privateBackupPath, // Store private path in database
  //           'public_path': publicBackupPath.isNotEmpty ? publicBackupPath : null,
  //           'size': privateBackupStat.size,
  //           'created_at': DateTime.now().toIso8601String(),
  //         },
  //         conflictAlgorithm: ConflictAlgorithm.replace,
  //       );
  //       print('💾 Backup record saved to database');

  //       // Return success with paths info
  //       if (publicBackupPath.isNotEmpty) {
  //         return '${SqfliteCodes.successCode}|$privateBackupPath|$publicBackupPath';
  //       } else {
  //         return '${SqfliteCodes.successCode}|$privateBackupPath';
  //       }
  //     } finally {
  //       (await SqflitePackage.instance).close();
  //     }
  //   } on DatabaseException catch (e) {
  //     final msg = e.toString();
  //     print('❌ DatabaseException during backup: $msg');

  //     if (e.isOpenFailedError()) {
  //       throw AppException(msg, SqfliteCodes.dbOpenFailed);
  //     } else if (e.isSyntaxError()) {
  //       throw AppException(msg, SqfliteCodes.sqlSyntaxError);
  //     } else if (e.isNoSuchTableError()) {
  //       throw AppException(msg, SqfliteCodes.tableNotFound);
  //     } else if (e.isDatabaseClosedError()) {
  //       throw AppException(msg, SqfliteCodes.dbClosed);
  //     } else if (msg.contains("UNIQUE constraint failed")) {
  //       throw AppException(msg, SqfliteCodes.uniqueConstraintFailed);
  //     } else if (msg.contains("foreign key constraint")) {
  //       throw AppException(msg, SqfliteCodes.foreignKeyConstraintFailed);
  //     } else {
  //       throw AppException(msg, SqfliteCodes.databaseException);
  //     }
  //   } on AppException catch (_) {
  //     rethrow;
  //   } catch (e) {
  //     print('❌ Unexpected error during backup: $e');
  //     throw AppException('Unexpected error during backup: ${e.toString()}', '500');
  //   }
  // }