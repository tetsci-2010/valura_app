import 'package:go_router/go_router.dart';
import 'package:valura/features/screens/initial_screens/splash_screen.dart';
import 'package:valura/features/screens/main_screens/create_item_screen/create_item_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/features/screens/main_screens/main_home_screen/main_home_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: SplashScreen.id,
  routes: [
    GoRoute(
      path: SplashScreen.id,
      name: SplashScreen.name,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: HomeScreen.id,
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: CreateItemScreen.id,
      name: CreateItemScreen.name,
      builder: (context, state) => CreateItemScreen(),
    ),
    GoRoute(
      path: MainHomeScreen.id,
      name: MainHomeScreen.name,
      builder: (context, state) => MainHomeScreen(),
    ),
  ],
);
