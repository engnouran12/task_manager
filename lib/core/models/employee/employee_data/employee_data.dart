import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'phone_number.dart';

class EmployeeData extends Equatable {
  final bool? hidden;
  final String? id;
  final String? img;
  final String firstName;
  final String secondName;
  final String email;
  final PhoneNumber phoneNumber;
  final String address;
  final String? role;
  final Speciality specialityId; // Type: Speciality

  const EmployeeData({
    this.hidden,
    this.id,
    this.img,
    this.role,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.specialityId,
  });

  factory EmployeeData.fromMap(Map<String, dynamic> data) {
    try {
      return EmployeeData(
        role: data['role'] as String? ?? '',
        img: data['img'] as String? ?? '',
        hidden: data['hidden'] as bool? ?? false,
        id: data['_id'] as String? ?? '',
        firstName: data['firstName'] as String? ?? 'unknown',
        secondName: data['secondName'] as String? ?? 'unknown',
        email: data['email'] as String? ?? '',
        phoneNumber: PhoneNumber.fromMap(data['phoneNumber'] as Map<String, dynamic>? ?? {}),
        address: data['address'] as String? ?? '',
        specialityId: Speciality.fromMap(data['speciality_id'] as Map<String, dynamic>? ?? {}), // Ensure correct type
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() => {
    'img': img,
    'hidden': hidden,
    'firstName': firstName,
    'secondName': secondName,
    'email': email,
    'phoneNumber': phoneNumber.toMap(),
    'address': address,
    'speciality_id': specialityId.id, // Ensure conversion to Map<String, dynamic>
  };

  factory EmployeeData.fromJson(String data) {
    return EmployeeData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  EmployeeData copyWith({
    String? img,
    bool? hidden,
    String? id,
    String? firstName,
    String? secondName,
    String? email,
    PhoneNumber? phoneNumber,
    String? address,
    Speciality? specialityId, // Change type to Speciality
  }) {
    return EmployeeData(
      img: img ?? this.img,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      specialityId: specialityId ?? this.specialityId, // Ensure type consistency
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      hidden,
      firstName,
      secondName,
      email,
      phoneNumber,
      address,
      specialityId,
    ];
  }
}

