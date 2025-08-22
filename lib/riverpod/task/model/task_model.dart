import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  String id;
  String title;
  String description;
  String employee_id;
  String manager_id;
  String employee_name;
  String manager_name;
  String status; // e.g., pending, in-progress, completed
  DateTime due_date;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.employee_id,
    required this.manager_id,
    required this.employee_name,
    required this.manager_name,
    required this.status,
    required this.due_date,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
