import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
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
}
