import 'package:shared_preferences/shared_preferences.dart';

abstract class DataHelper {
  static late final SharedPreferences _data;

  static Future<void> loadData() async {
    _data = await SharedPreferences.getInstance();
  }

  static int? getInt(String key, int? defaultValue) {
    return _data.getInt(key) ?? defaultValue;
  }

  static void setInt(String key, int value) {
    _data.setInt(key, value);
  }

  static String? getString(String key, String? defaultValue) {
    return _data.getString(key) ?? defaultValue;
  }

  static void setString(String key, String value) {
    _data.setString(key, value);
  }

  static bool? getBool(String key, bool? defaultValue) {
    return _data.getBool(key) ?? defaultValue;
  }

  static void setBool(String key, bool value) {
    _data.setBool(key, value);
  }

  static double? getDouble(String key, double? defaultValue) {
    return _data.getDouble(key) ?? defaultValue;
  }

  static void setDouble(String key, double value) {
    _data.setDouble(key, value);
  }

  static List<String>? getStringList(String key, List<String>? defaultValue) {
    return _data.getStringList(key) ?? defaultValue;
  }

  static void setStringList(String key, List<String> value) {
    _data.setStringList(key, value);
  }
}
