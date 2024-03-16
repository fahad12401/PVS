import 'package:shared_preferences/shared_preferences.dart';

class UserPerference {
  static const String _IsloggedinKey = "evs";
  static Future<bool> isLoggedin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IsloggedinKey) ?? false;
  }

  static Future<void> setLoggedin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_IsloggedinKey, isLogin);
  }
}
