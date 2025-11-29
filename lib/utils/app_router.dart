import 'package:go_router/go_router.dart';
import 'package:valura/features/screens/initial_screens/splash_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';

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
  ],
);
