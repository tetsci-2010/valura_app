import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/backup_model.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/features/data/repository/local_idata_repository/local_idata_repository.dart';

class ItemService {
  final LocalDataRepositoryImp localDataRepositoryImp;

  const ItemService({required this.localDataRepositoryImp});

  Future<String> storeItem(ItemModel itemModel) async {
    try {
      final result = await localDataRepositoryImp.storeItem(itemModel);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> storeProduct(ProductFormModel product) async {
    try {
      final result = await localDataRepositoryImp.storeProduct(product);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<ProductModel>> fetchProducts({Sort? sort}) async {
    try {
      final result = await localDataRepositoryImp.fetchProducts(sort: sort);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> deleteProduct(int? id) async {
    try {
      final result = await localDataRepositoryImp.deleteProduct(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<ItemModel>> fetchProductDetails(int id) async {
    try {
      final result = await localDataRepositoryImp.fetchProductDetails(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<ItemModel?> editProductDetails(int id) async {
    try {
      final result = await localDataRepositoryImp.editProductDetails(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> deleteProductDetail({required int id, required int pId}) async {
    try {
      final result = await localDataRepositoryImp.deleteProductDetail(id: id, pId: pId);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> updateProductDetail({required ItemModel item, required int pId}) async {
    try {
      final result = await localDataRepositoryImp.updateProductDetail(item: item, pId: pId);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> backupDB() async {
    try {
      final result = await localDataRepositoryImp.backupDB();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<BackupModel>> fetchBackups() async {
    try {
      final result = await localDataRepositoryImp.fetchBackups();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> restoreBackup() async {
    try {
      final result = await localDataRepositoryImp.restoreBackup();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> deleteItem(int? id) async {
    try {
      final result = await localDataRepositoryImp.deleteItem(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<ItemModel> editItem(int id) async {
    try {
      final result = await localDataRepositoryImp.editItem(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<List<ItemModel>> fetchItems(Sort? sort) async {
    try {
      final result = await localDataRepositoryImp.fetchItems(sort);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> updateItem(ItemModel item) async {
    try {
      final result = await localDataRepositoryImp.updateItem(item);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
