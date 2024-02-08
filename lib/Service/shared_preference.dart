import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<bool> isDataSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('my_data_key');
  }

  static Future<void> toggleDataSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = await isDataSaved();
    if (isSaved) {
      await prefs.remove('my_data_key');
    } else {
      await prefs.setBool('my_data_key', true);
    }
  }
}
