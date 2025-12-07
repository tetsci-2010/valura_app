import 'package:get_it/get_it.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/data/repository/local_idata_repository/local_idata_repository.dart';
import 'package:valura/features/data/services/item_service.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  /// 🔹 BLOCS
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());

  /// 🔹 BLOCS
  di.registerLazySingleton(() => AppProvider());

  ///
  di.registerLazySingleton<LocalDataRepositoryImp>(() => localIDataRepository);

  ///
  di.registerLazySingleton(() => ItemService(localDataRepositoryImp: di()));

  ///
  di.registerLazySingleton(() => CreateItemBloc(di()));
}
