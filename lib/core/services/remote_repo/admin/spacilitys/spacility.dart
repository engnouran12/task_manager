import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';

class SpecialityServices {
  final String specialitiesUrl = 'http://66.29.130.92:5070/api/speciality/';


  SpecialityServices() ;


  Future<void> addSpeciality(Speciality speciality) async {
    try {
      final response = await http.post(
        Uri.parse(specialitiesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(speciality.toJson()),
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to add speciality: ${data['message']}');
        }
      } else {
        throw Exception('Failed to add speciality: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error adding speciality: $e');
    }
  }

  Future<List<Speciality>> getAllSpecialities() async {
    try {

      final response = await http.get(
        Uri.parse(specialitiesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          // print('Specialtys data: ${data['payload']}');
          return List<Speciality>.from(
            data['payload'].map((speciality) => Speciality.fromJson(speciality)),
          );
        } else {
          throw Exception('Failed to get specialities: ${data['message']}');
        }
      } else {
        throw Exception('Failed to get specialities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<void> editSpeciality(String id, Speciality speciality) async {
    try {

      final response = await http.put(
        Uri.parse('$specialitiesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(speciality.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to edit speciality');
        }
      } else {
        throw Exception('Failed to edit speciality');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteSpeciality(String id) async {
    try {

      final response = await http.delete(
        Uri.parse('$specialitiesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
        } else {
          throw Exception('Failed to delete speciality');
        }
      } else {
        throw Exception('Failed to delete speciality');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Speciality> findSpecialityById(String id) async {
    try {

      final response = await http.get(
        Uri.parse('$specialitiesUrl$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return Speciality.fromJson(data['payload']);
        } else {
          throw Exception('Failed to find speciality');
        }
      } else {
        throw Exception('Failed to find speciality');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Speciality> findSpecialityByName(String name) async {
    try {

      final response = await http.get(
        Uri.parse('$specialitiesUrl?name=$name'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['type'] == 'success') {
          return Speciality.fromJson(data['payload']);
        } else {
          throw Exception('Failed to find speciality');
        }
      } else {
        throw Exception('Failed to find speciality');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
