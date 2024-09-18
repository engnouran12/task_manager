import 'dart:convert';

import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  final String dialCode;
  final String phoneNumber;

  const PhoneNumber({required this.dialCode, required this.phoneNumber,});

  factory PhoneNumber.fromMap(Map<String, dynamic> data) => PhoneNumber(
        dialCode: data['dialCode'] as String? ?? '',
        phoneNumber: data['phoneNumber'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'dialCode': dialCode,
        'phoneNumber': phoneNumber,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PhoneNumber].
  factory PhoneNumber.fromJson(String data) {
    return PhoneNumber.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PhoneNumber] to a JSON string.
  String toJson() => json.encode(toMap());

  PhoneNumber copyWith({
    String? dialCode,
    String? phoneNumber,
  }) {
    return PhoneNumber(
      dialCode: dialCode ?? this.dialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [dialCode, phoneNumber];
}
