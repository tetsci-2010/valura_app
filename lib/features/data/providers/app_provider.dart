import 'package:flutter/material.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/utils/random_color.dart';

class AppProvider extends ChangeNotifier {
  int _selectedIndex = 0;
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

  void clearDropDownItems() {
    dropDownItems = [];
    notifyListeners();
  }

  final Map<int, Color> _colorCache = {};

  Color getStableColor(int index) {
    if (_colorCache.containsKey(index)) {
      return _colorCache[index]!;
    }
    final newColor = randomVibrantColorWithAlpha();
    _colorCache[index] = newColor;
    return newColor;
  }
}
