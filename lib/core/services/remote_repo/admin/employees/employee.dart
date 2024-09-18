import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';

class EmployeeServices {

  final String employeesUrl = 'http://66.29.130.92:5070/api/employees/';
  

  EmployeeServices();



  Future<void> addEmployee(Employee employeeData) async {
    try {
      final response = await http.post(
        Uri.parse(employeesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(employeeData.toJson()),
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // print('payload: ${data['payload']}');
          return data['payload'];
        } else {
          throw Exception('Failed to add employee');
        }
      } else {
        throw Exception('Failed to add employee');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<EmployeeData> getEmployeeById(String id) async {
    try {
     
      final response = await http.get(
        Uri.parse('$employeesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // print('payload: ${data['payload']}');

          final payload = data['payload'];
          if (payload != null && payload is Map<String, dynamic>) {
            return EmployeeData.fromMap(payload);
          } else {
            throw Exception('Payload is null or not a Map');
          }
        } else {
          throw Exception('Failed to find employee');
        }
      } else {
        throw Exception('Failed to find employee');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<List<EmployeeData>> getAllEmployees() async {
    try {
      // Ensure initialization is complete
      final response = await http.get(
        Uri.parse(employeesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // // Log detailed request and response info
      // print('Request URL: ${response.request?.url}');
      // print('Response status: ${response.statusCode}');
      // print('Response headers: ${response.headers}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          final List<dynamic>? employeesList = data['payload'] as List<dynamic>?;
          if (employeesList != null) {
            return employeesList.map((employee) {
              if (employee is Map<String, dynamic>) {
                return EmployeeData.fromMap(employee);
              } else {
                throw Exception('Unexpected data format');
              }
            }).toList();
          } else {
            return [];
          }
        } else {
          throw Exception('Failed to get employees: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to get employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



  Future<void> editEmployee(String id, EmployeeData employeeData) async {
    try {
      final body = json.encode(employeeData.toMap());
      // print('Request body: $body'); // Debug print

      final response = await http.put(
        Uri.parse('$employeesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return;
        } else {
          throw Exception('Failed to edit employee: ${data['message']}');
        }
      } else {
        throw Exception('Failed to edit employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



  Future<void> deleteEmployee(String id) async {
    try {
     
      final response = await http.delete(
        Uri.parse('$employeesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return;
        } else {
          throw Exception('Failed to delete employee');
        }
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
