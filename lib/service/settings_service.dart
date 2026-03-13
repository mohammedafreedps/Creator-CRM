import 'package:shared_preferences/shared_preferences.dart';
import '../constants/settings.dart';

class SettingsService {
  static SharedPreferences? _prefs;

  /// initialize once when app starts
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get enableDelete {
    return _prefs?.getBool(AppSettings.enableDelete) ?? false;
  }

  static Future setEnableDelete(bool value) async {
    await _prefs?.setBool(AppSettings.enableDelete, value);
  }
}