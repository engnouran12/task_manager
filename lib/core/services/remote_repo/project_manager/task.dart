// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:task_manager/core/models/projects/project_model.dart';
// import 'package:task_manager/core/models/Speciality/speciality_model.dart';
// import 'package:task_manager/core/models/task/task_model.dart';

// class TaskServices {
//   final String projectUrl = 'http://66.29.130.92:5070/api/task';
//   final String authorizationToken =
//       'eyJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2NmI3NTYzMDMzMmM4MGZkZTAyYTMwMDUiLCJlbWFpbCI6InlvdXNzZWZAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoieW91c3NlZiIsInNlY29uZE5hbWUiOiJhc2hyZiIsInBob25lTnVtYmVyIjp7ImRpYWxDb2RlIjoiKzIwIiwicGhvbmVOdW1iZXIiOiIwMTE0MDkwODQzNCIsIl9pZCI6IjY2YjcyMjUyZjM3NDFhNWYwNjFmNDA3MyJ9LCJhZGRyZXNzIjoiMTYg2LTYp9ix2Lkg2LnYqNiv2KfZhNmF2KrYudin2YQiLCJzcGVjaWFsaXR5X2lkIjpudWxsLCJpbWciOiJ1cGxvYWRzL3VzZXIuanBnIiwicm9sZSI6ImFkbWluIn0.U5ZjO7ZxiI6rT2Ka9rm-I05YME3OV9mmR3KQb6Sm7Tc';

//   Future<void> addtask(TaskModel task) async {
//     try {
//       final response = await http.post(
//         Uri.parse(projectUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//         body: json.encode(
//           task.toJson()
//         ),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           print('task added successfully');
//         } else {
//           throw Exception('Failed to add task');
//         }
//       } else {
//         throw Exception('Failed to add task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<List<TaskModel>> getAllTasks() async {
//     try {
//       final response = await http.get(
//         Uri.parse(projectUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           return List<TaskModel>.from(
//             data['payload']
//                 .map((speciality) => Speciality.fromJson(speciality)),
//           );
//         } else {
//           throw Exception('Failed to get Tasks');
//         }
//       } else {
//         throw Exception('Failed to get TAsks');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<void> edittask(String id, TaskModel task) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$projectUrl$id'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//         body: json.encode(task.toJson()),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           print('task edited successfully');
//         } else {
//           throw Exception('Failed to edit task');
//         }
//       } else {
//         throw Exception('Failed to edit task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<void> deletetask(String id) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('$projectUrl$id'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           print('task deleted successfully');
//         } else {
//           throw Exception('Failed to delete task');
//         }
//       } else {
//         throw Exception('Failed to delete task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<TaskModel> findTaskById(String id) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$projectUrl$id'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           return TaskModel.fromJson(data['payload']);
//         } else {
//           throw Exception('Failed to find task');
//         }
//       } else {
//         throw Exception('Failed to find task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<TaskModel> findTaskByName(String name) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$projectUrl?name=$name'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           return TaskModel.fromJson(data['payload']);
//         } else {
//           throw Exception('Failed to find task');
//         }
//       } else {
//         throw Exception('Failed to find task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<TaskModel> findTaskByProject(String project) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$projectUrl?name=$project'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': authorizationToken,
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         if (data['type'] == 'success') {
//           return TaskModel.fromJson(data['payload']);
//         } else {
//           throw Exception('Failed to find task');
//         }
//       } else {
//         throw Exception('Failed to find task');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }
