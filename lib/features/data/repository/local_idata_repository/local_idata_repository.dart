import 'package:valura/constants/exceptions.dart';
import 'package:valura/features/data/models/item_model.dart';
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
      throw AppException(errorMessage: e.toString());
    }
  }
}
