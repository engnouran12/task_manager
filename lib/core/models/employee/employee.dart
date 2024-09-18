
import 'package:task_manager/core/models/employee/employee_data/phone_number.dart';

class Employee {
  final String? img;
  final bool? hidden;
  final String? id;
  final String email;
  final String? role;
  final String firstName;
  final String secondName;
  final String password;
  final PhoneNumber phoneNumber;
  final String address;
  final String specialityId;

  Employee({
    this.hidden,
    this.id ,
    this.img,
    required this.email,
   this.role,
    required this.password,
    required this.firstName,
    required this.secondName,
    required this.phoneNumber,
    required this.address,
    required this.specialityId,
  });

  factory Employee.fromJson(Map<String, dynamic> data) {
    return Employee(
      img: data['img']as String? ?? '',
      hidden: (data['hidden'] as bool?) ?? false,
      id: data['_id'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'employee',
      firstName: data['firstName'] as String? ?? '',
      secondName: data['secondName'] as String? ?? '',
      password: data['password'] as String? ?? '',
      phoneNumber:
           PhoneNumber.fromMap(data['phoneNumber'] as Map<String, dynamic>),
      address: data['address'] as String? ??'',
      specialityId: data['speciality_id'] as String? ?? '',
           // Provide a default Speciality if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'secondName': secondName,
      'password': password,
      'phoneNumber': phoneNumber.toMap(), // Convert PhoneNumber to a Map
      'address': address,
      'speciality_id': specialityId, // Convert Speciality to a Map
    };
  }
}
