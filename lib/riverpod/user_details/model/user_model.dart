import 'package:json_annotation/json_annotation.dart';
import 'package:postgrest/src/types.dart';
part 'user_model.g.dart';
@JsonSerializable()
class UserModel {
  String name;
  String email;
  String role;
  String department;
  bool is_approved;
  int mobile;
  String id;

  UserModel({
    required this.name,
    required this.department,
    required this.email,
    required this.id,
    required this.is_approved,
    required this.mobile,
    required this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> tojson() => _$UserModelToJson(this);

  static fromMap(PostgrestMap userData) {}
}
