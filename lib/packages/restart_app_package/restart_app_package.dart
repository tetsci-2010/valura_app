import 'package:restart_app/restart_app.dart';

class RestartAppPackage {
  static Future<void> restartApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      await Restart.restartApp();
    } catch (e) {
      print('Restart App Error: $e');
    }
  }
}
