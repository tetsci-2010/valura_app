import 'package:sqflite/sqflite.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';

abstract class ILocalDataDataSource {
  Future<String> storeItem(ItemModel itemModel);
  Future<String> storeProduct(ProductFormModel product);
  Future<List<ProductModel>> fetchProducts({Sort? sort});
  Future<String> deleteProduct(int? id);
  Future<List<ItemModel>> fetchProductDetails(int id);
  Future<ItemModel?> editProductDetails(int id);
  Future<String> deleteProductDetail({required int id, required int pId});
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
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }

  @override
  Future<String> deleteProductDetail({required int id, required int pId}) async {
    try {
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

        final count = Sqflite.firstIntValue(remaining) ?? 0;

        if (count == 0) {
          await txn.delete(
            productsTable,
            where: 'id = ?',
            whereArgs: [pId],
          );
        }
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
    } catch (e) {
      throw AppException(e.toString(), '500');
    }
  }
}
