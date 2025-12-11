import 'package:sqflite/sqflite.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';

abstract class ILocalDataDataSource {
  Future<String> storeItem(ItemModel itemModel);
  Future<String> storeProduct(ProductFormModel product);
  Future<List<ProductModel>> fetchProducts();
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
        throw AppException(SqfliteCodes.dbOpenFailed, '1105');
      } else if (e.isSyntaxError()) {
        throw AppException(SqfliteCodes.sqlSyntaxError, '1103');
      } else if (e.isNoSuchTableError()) {
        throw AppException(SqfliteCodes.tableNotFound, '1102');
      } else if (e.isDatabaseClosedError()) {
        throw AppException(SqfliteCodes.dbClosed, '1104');
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(SqfliteCodes.uniqueConstraintFailed, '1100');
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(SqfliteCodes.foreignKeyConstraintFailed, '1101');
      } else {
        throw AppException(SqfliteCodes.databaseException, '1000');
      }
    } catch (e) {
      throw AppException(SqfliteCodes.unknowDatabaseError, '1999');
    }
  }

  @override
  Future<String> storeProduct(ProductFormModel product) async {
    try {
      for (var i = 0; i < product.names.length; i++) {
        await (await SqflitePackage.instance).transaction(
          (txn) async {
            final index = await txn.insert(
              productsTable,
              {
                'name': product.name,
                'total': product.total,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            await txn.insert(
              productDetailsTable,
              {
                'product_id': index,
                'name': product.names[i],
                'purchase_rate': product.purchaseRates[i],
                'land_cost': product.landCosts[i],
                'cost': product.costs[i],
                'new_rate': product.newRates[i],
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          },
        );
      }
      return SqfliteCodes.successCode;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(SqfliteCodes.dbOpenFailed, '1105');
      } else if (e.isSyntaxError()) {
        throw AppException(SqfliteCodes.sqlSyntaxError, '1103');
      } else if (e.isNoSuchTableError()) {
        throw AppException(SqfliteCodes.tableNotFound, '1102');
      } else if (e.isDatabaseClosedError()) {
        throw AppException(SqfliteCodes.dbClosed, '1104');
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(SqfliteCodes.uniqueConstraintFailed, '1100');
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(SqfliteCodes.foreignKeyConstraintFailed, '1101');
      } else {
        throw AppException(SqfliteCodes.databaseException, '1000');
      }
    } catch (e) {
      throw AppException(SqfliteCodes.unknowDatabaseError, '1999');
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      SqflitePackage db = SqflitePackage();
      List<Map<String, dynamic>> products = await db.query(table: productsTable);
      List<ProductModel> pProducts = [];
      for (var product in products) {
        List<Map<String, dynamic>> items = await db.query(table: productDetailsTable);
        print(items);
        return [];
        List<ItemModel> pItems = items.map((e) => ItemModel.fromDB(e)).toList();
        pProducts.add(ProductModel(id: product['id'], name: product['name'], total: product['total'], items: pItems));
      }
      return pProducts;
    } on DatabaseException catch (e) {
      final msg = e.toString();
      if (e.isOpenFailedError()) {
        throw AppException(SqfliteCodes.dbOpenFailed, '1105');
      } else if (e.isSyntaxError()) {
        throw AppException(SqfliteCodes.sqlSyntaxError, '1103');
      } else if (e.isNoSuchTableError()) {
        throw AppException(SqfliteCodes.tableNotFound, '1102');
      } else if (e.isDatabaseClosedError()) {
        throw AppException(SqfliteCodes.dbClosed, '1104');
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(SqfliteCodes.uniqueConstraintFailed, '1100');
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(SqfliteCodes.foreignKeyConstraintFailed, '1101');
      } else {
        throw AppException(SqfliteCodes.databaseException, '1000');
      }
    } catch (e) {
      throw AppException(e.toString(), '1999');
    }
  }
}
