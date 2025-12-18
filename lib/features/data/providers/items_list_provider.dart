import 'package:flutter/material.dart';

class ItemsListProvider extends ChangeNotifier {
  int layout = 2;
  void toggleLayout() {
    if (layout == 1) {
      layout = 2;
    } else {
      layout = 1;
    }
    notifyListeners();
  }
}
