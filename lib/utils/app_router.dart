import 'package:go_router/go_router.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/screens/initial_screens/splash_screen.dart';
import 'package:valura/features/screens/main_screens/create_item_screen/create_item_screen.dart';
import 'package:valura/features/screens/main_screens/edit_item_screen/edit_item_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/features/screens/main_screens/main_home_screen/main_home_screen.dart';
import 'package:valura/features/screens/main_screens/product_details_screen/product_details_screen.dart';

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
    GoRoute(
      path: ProductDetailsScreen.id,
      name: ProductDetailsScreen.name,
      builder: (context, state) {
        Map<String, dynamic> jsonData = state.extra as Map<String, dynamic>;
        int productId = jsonData['product_id'] as int;
        String productName = jsonData['product_name'] as String;
        return ProductDetailsScreen(productId: productId, productName: productName);
      },
    ),
    GoRoute(
      path: EditItemScreen.id,
      name: EditItemScreen.name,
      builder: (context, state) {
        Map<String, dynamic> jsonData = state.extra as Map<String, dynamic>;
        ItemModel? item = jsonData['item_model'] as ItemModel?;
        int? itemId = jsonData['item_id'] as int?;
        return EditItemScreen(itemModel: item, itemId: itemId);
      },
    ),
  ],
);
