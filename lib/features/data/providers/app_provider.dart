import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _selectedIndex = 1;
  int get getSelectedScreen => _selectedIndex;
  void updateSelectedScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
