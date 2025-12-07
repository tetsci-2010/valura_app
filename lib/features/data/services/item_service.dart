import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
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
      throw AppException(errorMessage: e.toString());
    }
  }
}
