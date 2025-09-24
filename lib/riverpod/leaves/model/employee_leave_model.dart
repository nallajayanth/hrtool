import 'package:json_annotation/json_annotation.dart';
part 'employee_leave_model.g.dart';

@JsonSerializable()
class EmployeeLeaveModel {
  String? name;
  String? user_id;
  String? leave_type;
  String? reason;
  String? start_date;
  String? end_date;
  String? status;
  String? approved_at;
  String? appiled_at;

  EmployeeLeaveModel({
    this.user_id,
    this.leave_type,
    this.reason,
    this.appiled_at,
    this.approved_at,
    this.end_date,
    this.name,
    this.start_date,
    this.status,
  });
  factory EmployeeLeaveModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeLeaveModelFromJson(json);
  Map<String, dynamic> tojson() => _$EmployeeLeaveModelToJson(this);
}
