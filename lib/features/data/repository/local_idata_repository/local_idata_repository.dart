import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/features/data/source/local_idata_data_source/local_idata_data_source.dart';

final localIDataRepository = LocalDataRepositoryImp(LocalDataDataSourceImp());

abstract class ILocalDataRepository extends ILocalDataDataSource {}

class LocalDataRepositoryImp implements ILocalDataRepository {
  final ILocalDataDataSource localDataDataSource;

  const LocalDataRepositoryImp(this.localDataDataSource);

  @override
  Future<String> storeItem(ItemModel itemModel) async {
    try {
      final result = await localDataDataSource.storeItem(itemModel);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> storeProduct(ProductFormModel product) async {
    try {
      final result = await localDataDataSource.storeProduct(product);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts({Sort? sort}) async {
    try {
      final result = await localDataDataSource.fetchProducts(sort: sort);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> deleteProduct(int? id) async {
    try {
      final result = await localDataDataSource.deleteProduct(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ItemModel>> fetchProductDetails(int id) async {
    try {
      final result = await localDataDataSource.fetchProductDetails(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ItemModel?> editProductDetails(int id) async {
    try {
      final result = await localDataDataSource.editProductDetails(id);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> deleteProductDetail({required int id, required int pId}) async {
    try {
      final result = await localDataDataSource.deleteProductDetail(id: id, pId: pId);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
