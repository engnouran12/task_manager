import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  final String url = 'http://66.29.130.92:5070/api/admin';

  Future<bool> checkAdminCreated() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return data['payload'];
        } else {
          throw Exception('Failed to load admin status');
        }
      } else {
        throw Exception('Failed to load admin status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> createAdmin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return true;
        } else {
          throw Exception('Failed to create admin');
        }
      } else {
        throw Exception('Failed to create admin');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
