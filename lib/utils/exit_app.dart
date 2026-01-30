import 'package:flutter/material.dart';
import 'package:valura/packages/toast_package/toast_package.dart';

class ExitApp {
  static int count = 0;
  static Future<bool> onWillPop(BuildContext context) async {
    count += 1;
    if (count < 2) ToastPackage.showSimpleToast(context: context, message: 'برای خروج دوباره امتحان کنید');
    if (count == 2) {
      return true;
    }
    await Future.delayed(const Duration(seconds: 2));
    count = 0;
    return false;
  }
}
