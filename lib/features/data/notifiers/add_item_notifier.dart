import 'package:flutter/material.dart';

class AddItemNotifier extends ChangeNotifier {
  static late ValueNotifier<num> total;

  static void disposeTotal() {
    try {
      total.dispose();
    } catch (_) {}
  }
}
