// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  employee_id: json['employee_id'] as String,
  manager_id: json['manager_id'] as String,
  employee_name: json['employee_name'] as String,
  manager_name: json['manager_name'] as String,
  status: json['status'] as String,
  due_date: DateTime.parse(json['due_date'] as String),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'employee_id': instance.employee_id,
  'manager_id': instance.manager_id,
  'employee_name': instance.employee_name,
  'manager_name': instance.manager_name,
  'status': instance.status,
  'due_date': instance.due_date.toIso8601String(),
};
