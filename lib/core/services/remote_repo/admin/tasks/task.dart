import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constant/const_url.dart';
import 'package:task_manager/core/models/task/task_model.dart';

class TasksService {
   Future<void> patchTaskStatus(String token,String taskId, bool doneStatus) async {
    final url = Uri.parse('$baseUrl/task/$taskId');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':token , 
      },
      body: json.encode({
        'done': doneStatus,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status');
    }
  }


  Future<void> addTask(TaskModel taskData,String token) async {
    try {
      final response = await http.post(
        Uri.parse(taskUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode(taskData.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // print('data${data}');
          return data['payload'];
        } else {
          // print(response.statusCode);
          throw Exception('Failed to add task');
        }
      } else {
        // print(response.statusCode);
        throw Exception('Failed to add task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TaskModel> getTaskById(String id,String token) async {
    try {
      final response = await http.get(
        Uri.parse('$taskUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return TaskModel.fromJson(data['payload']);
        } else {
          throw Exception('Failed to find task');
        }
      } else {
        throw Exception('Failed to find task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
 Future<List<TaskModel>> getTaskByProject(String projectid,String token) async {
    try {
      final response = await http.get(
        Uri.parse('$taskUrl/project/$projectid'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
         return List<TaskModel>.from(
            data['payload'].map((task) => TaskModel.fromJson(task)),
          );
        } else {
          throw Exception('Failed to find tasks');
        }
      } else {
        throw Exception('Failed to find task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TaskModel>> getAllTasks(String token) async {
    try {
      final response = await http.get(
        Uri.parse(taskUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return List<TaskModel>.from(
            data['payload'].map((task) => TaskModel.fromJson(task)),
          );
        } else {
          throw Exception('Failed to get tasks');
        }
      } else {
        throw Exception('Failed to get tasks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> editTask(String id,
   TaskModel taskData,String token) async {
    try {
      final response = await http.put(
        Uri.parse('$taskUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode(taskData.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return;
        } else {
          throw Exception('Failed to edit task');
        }
      } else {
        throw Exception('Failed to edit task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteTask(String id,String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$taskUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return;
        } else {
          throw Exception('Failed to delete task');
        }
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
