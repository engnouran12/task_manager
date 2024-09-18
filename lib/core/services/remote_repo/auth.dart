import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constant/constant.dart';

class AuthService {
 // SecureStorageService? _secureStorageService;
  final String loginUrl = 'http://66.29.130.92:5070/api/employees/login';
  final String logoutUrl = 'http://66.29.130.92:5070/api/employees/logout';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // print('Response Data: $data'); // Log response data
        if (data['type'] == 'success') {
          //save token
         // _secureStorageService!.saveToken(data['payload']['token']);
          return {
            'token': data['payload']['token'],
            'employee': data['payload']['employee'],
          };
        } else {
          throw Exception(
              'Login failed: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Login failed with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // print('Logout successful: ${data['payload']}');
        } else {
          throw Exception('Logout failed');
        }
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
