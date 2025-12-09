import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/l10n/app_l10n.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/utils/app_router.dart';
import 'package:valura/utils/app_theme.dart';
import 'package:valura/utils/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  await di.allReady();
  // 🔒 Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SqflitePackage.resetDatabase();
  await SqflitePackage.database;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di<AppProvider>()),
        ChangeNotifierProvider(create: (context) => di<AddItemProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di<LocalizationBloc>()),
          BlocProvider(create: (context) => di<CreateItemBloc>()),
        ],
        child: ScreenUtilInit(
          designSize: Size(392.72727272727275, 856.7272727272727),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<LocalizationBloc, LocalizationState>(
              buildWhen: (previous, current) => previous.selectedLanguage != current.selectedLanguage,
              builder: (context, state) {
                return MaterialApp.router(
                  title: 'Valura',
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.system,
                  darkTheme: AppTheme.darkTheme(context),
                  theme: AppTheme.lightTheme(context),
                  routerConfig: appRouter,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: state.selectedLanguage.value,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
