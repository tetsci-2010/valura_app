import 'package:flutter/material.dart';
import 'package:valura/features/data/models/item_model.dart';

class AppProvider extends ChangeNotifier {
  int _selectedIndex = 1;
  int get getSelectedScreen => _selectedIndex;
  void updateSelectedScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  List<ItemModel> dropDownItems = [];
  void updateDropDownItems({List<ItemModel>? items, ItemModel? item}) {
    final toUpdate = items ?? (item != null ? [item] : []);

    for (var newItem in toUpdate) {
      final index = dropDownItems.indexWhere((e) => e.id == newItem.id);
      if (index >= 0) {
        dropDownItems[index] = newItem; // Replace in place
      } else {
        dropDownItems.insert(0, newItem); // Add new item at front
      }
    }
  }
}
