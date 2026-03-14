import 'package:equatable/equatable.dart';

class Speciality extends Equatable {
  final String? id;
  final String name;
  final bool? hidden;

  const Speciality({this.id, required this.name, this.hidden});

  factory Speciality.fromMap(Map<String, dynamic> json) {
    return Speciality(
      hidden: json['hidden'] as bool? ?? false,
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality.fromMap(json);
  }

  @override
  List<Object?> get props => [id, name, hidden];
}
