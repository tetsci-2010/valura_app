import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int homeBuilderLayout = 2;
  void toggleBuilderLayout() {
    if (homeBuilderLayout == 2) {
      homeBuilderLayout = 1;
    } else {
      homeBuilderLayout = 2;
    }
    notifyListeners();
  }
}
