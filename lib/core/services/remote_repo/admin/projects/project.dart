import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/projects/project_model.dart';

class ProjectServices {
  final String projectUrl = 'http://66.29.130.92:5070/api/project/';
 
  ProjectServices();

 
  Future<void> addproject(ProjectModel project) async {
    try {
      
      final response = await http.post(
        Uri.parse(projectUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token',
        },
        body: json.encode(project.toJson()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to add project');
        }
      } else {
        throw Exception('Failed to add project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProjectModel>> getAllProjects() async {
    try {
      
      final response = await http.get(
        Uri.parse(projectUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // Ensure that the payload is a list of maps
          List<dynamic> payload = data['payload'];
          return payload.map((item) => ProjectModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Failed to get projects');
        }
      } else {
        throw Exception('Failed to get projects');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<void> editProject(String id, ProjectModel project) async {
    try {
      
      final response = await http.put(
        Uri.parse('$projectUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(project.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to edit project');
        }
      } else {
        throw Exception('Failed to edit project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      
      final response = await http.delete(
        Uri.parse('$projectUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to delete project');
        }
      } else {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProjectModel> findProjectById(String id) async {
    try {
      

      final response = await http.get(
        Uri.parse('$projectUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return ProjectModel.fromJson(data['payload']);
        } else {
          throw Exception('Failed to find project');
        }
      } else {
        throw Exception('Failed to find project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProjectModel> findProjectByName(String name) async {
    try {
      
      final response = await http.get(
        Uri.parse('$projectUrl?name=$name'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return ProjectModel.fromJson(data['payload']);
        } else {
          throw Exception('Failed to find project');
        }
      } else {
        throw Exception('Failed to find project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ProjectModel>> findProjectByEmployee(String id) async {
    try {

      final response = await http.get(
        Uri.parse('${projectUrl}employee/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // print('Request URL: ${response.request?.url}');
      // print('Response status: ${response.statusCode}');
      // print('Response headers: ${response.headers}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // Ensure that the payload is a list of maps
          List<dynamic> payload = data['payload'];
          // print('payload: $payload');
          return payload.map((item) => ProjectModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Failed to get projects');
        }
      } else {
        throw Exception('Failed to get projects');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
