import 'package:get_it/get_it.dart';
import 'package:valura/features/data/blocs/backup_bloc/backup_bloc.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/blocs/edit_item_bloc/edit_item_bloc.dart';
import 'package:valura/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:valura/features/data/blocs/items_list_bloc/items_list_bloc.dart';
import 'package:valura/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:valura/features/data/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/data/providers/home_provider.dart';
import 'package:valura/features/data/providers/items_list_provider.dart';
import 'package:valura/features/data/repository/local_idata_repository/local_idata_repository.dart';
import 'package:valura/features/data/services/item_service.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  /// 🔹 BLOCS
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());

  /// 🔹 App provider
  di.registerLazySingleton(() => AppProvider());

  /// 🔹 Add Item Provider
  di.registerLazySingleton(() => AddItemProvider());

  /// 🔹 Home Provider
  di.registerLazySingleton(() => HomeProvider());

  /// 🔹 Home Provider
  di.registerLazySingleton(() => ItemsListProvider());

  ///
  di.registerLazySingleton<LocalDataRepositoryImp>(() => localIDataRepository);

  ///
  di.registerLazySingleton(() => ItemService(localDataRepositoryImp: di()));

  /// 🔹 Home Bloc
  di.registerLazySingleton<HomeBloc>(() => HomeBloc(di()));

  ///
  di.registerLazySingleton(() => CreateItemBloc(di(), di()));

  ///
  di.registerLazySingleton(() => ProductDetailsBloc(di(), di()));

  ///
  di.registerLazySingleton(() => EditItemBloc(di(), di(), di()));

  ///
  di.registerLazySingleton(() => BackupBloc(di()));

  ///
  di.registerLazySingleton(() => ItemsListBloc(di()));
}
