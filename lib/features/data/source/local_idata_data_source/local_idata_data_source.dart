import 'package:sqflite/sqflite.dart';
import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';

abstract class ILocalDataDataSource {
  Future<String> storeItem(ItemModel itemModel);
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
        throw AppException(errorMessage: SqfliteCodes.dbOpenFailed, statusCode: '1105');
      } else if (e.isSyntaxError()) {
        throw AppException(errorMessage: SqfliteCodes.sqlSyntaxError, statusCode: '1103');
      } else if (e.isNoSuchTableError()) {
        throw AppException(errorMessage: SqfliteCodes.tableNotFound, statusCode: '1102');
      } else if (e.isDatabaseClosedError()) {
        throw AppException(errorMessage: SqfliteCodes.dbClosed, statusCode: '1104');
      } else if (msg.contains("UNIQUE constraint failed")) {
        throw AppException(errorMessage: SqfliteCodes.uniqueConstraintFailed, statusCode: '1100');
      } else if (msg.contains("foreign key constraint")) {
        throw AppException(errorMessage: SqfliteCodes.foreignKeyConstraintFailed, statusCode: '1101');
      } else {
        throw AppException(errorMessage: SqfliteCodes.databaseException, statusCode: '1000');
      }
    } catch (e) {
      throw AppException(errorMessage: SqfliteCodes.unknowDatabaseError, statusCode: '1999');
    }
  }
}
