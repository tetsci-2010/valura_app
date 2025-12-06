import 'package:get_it/get_it.dart';
import 'package:valura/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:valura/features/data/providers/app_provider.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  /// 🔹 BLOCS
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());

  /// 🔹 BLOCS
  di.registerLazySingleton(() => AppProvider());
}
