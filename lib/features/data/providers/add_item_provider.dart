import 'package:flutter/material.dart';
import 'package:valura/features/data/models/item_model.dart';

class AddItemProvider extends ChangeNotifier {
  List<ItemModel> addedItems = [];
  void addItem(ItemModel item) {
    // if (addedItems.any((element) => element.id == item.id)) {
    //   addedItems.removeWhere((element) => element.id == item.id);
    //   addedItems.insert(0, item);
    // } else {
      addedItems.insert(0, item);
    // }
    notifyListeners();
  }
}
