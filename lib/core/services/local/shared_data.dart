import 'package:shared_preferences/shared_preferences.dart';

class LocalRepo {
  final SharedPreferences sharedPreferences;

  LocalRepo({required this.sharedPreferences});

  // Save token
  Future<void> addToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  // Clear all stored data (including token)
  Future<void> deleteToken() async {
    await sharedPreferences.clear();
  }

  // Update token
  Future<void> changeToken(String newToken) async {
    await sharedPreferences.setString('token', newToken);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return sharedPreferences.getString('token');
  }

  // Save a boolean value
  Future<void> putBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  // Save a string value
  Future<void> putString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  // Retrieve a boolean value
  Future<bool?> getBool(String key) async {
    return sharedPreferences.getBool(key);
  }

  // Retrieve a string value
  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }
}
