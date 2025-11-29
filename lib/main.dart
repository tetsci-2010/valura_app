import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valura/utils/app_router.dart';
import 'package:valura/utils/app_theme.dart';
import 'package:valura/utils/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  await di.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72727272727275, 856.7272727272727),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Valura',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          darkTheme: AppTheme.darkTheme(context),
          theme: AppTheme.lightTheme(context),
          routerConfig: appRouter,
        );
      },
    );
  }
}
