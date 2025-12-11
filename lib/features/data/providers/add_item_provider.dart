import 'package:flutter/material.dart';
import 'package:valura/features/data/models/item_model.dart';

class AddItemProvider extends ChangeNotifier {
  List<ItemModel> addedItems = [];
  num total = 0;

  // Add item (dedup + reassign list reference)
  void addItem(ItemModel item) {
    addedItems = [
      item,
      ...addedItems,
    ];
    _recalculateTotal();
    notifyListeners(); // single notify
  }

  // Remove item (reassign list reference after removal)
  void removeItemAt(int index) {
    if (index < 0 || index >= addedItems.length) return;

    addedItems = [
      ...addedItems..removeAt(index),
    ];

    _recalculateTotal();
    notifyListeners();
  }

  // private helper that does NOT call notifyListeners
  void _recalculateTotal() {
    total = addedItems.fold<num>(0, (prev, e) => prev + e.newRate);
  }
}
