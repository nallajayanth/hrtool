import 'package:json_annotation/json_annotation.dart';
part 'employee_attendence_model.g.dart';

@JsonSerializable()
class EmployeeAttendenceModel {
  String id;
  String user_id;
  String status;
  String date;
  EmployeeAttendenceModel({
    required this.id,
    required this.user_id,
    required this.status,
    required this.date
  });

  factory EmployeeAttendenceModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAttendenceModelFromJson(json);
  Map<String, dynamic> tojson() => _$EmployeeAttendenceModelToJson(this);
}
