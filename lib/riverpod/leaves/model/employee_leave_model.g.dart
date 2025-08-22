// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeLeaveModel _$EmployeeLeaveModelFromJson(Map<String, dynamic> json) =>
    EmployeeLeaveModel(
      user_id: json['user_id'] as String?,
      leave_type: json['leave_type'] as String?,
      reason: json['reason'] as String?,
      appiled_at: json['appiled_at'] as String?,
      approved_at: json['approved_at'] as String?,
      end_date: json['end_date'] as String?,
      name: json['name'] as String?,
      start_date: json['start_date'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$EmployeeLeaveModelToJson(EmployeeLeaveModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'user_id': instance.user_id,
      'leave_type': instance.leave_type,
      'reason': instance.reason,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'status': instance.status,
      'approved_at': instance.approved_at,
      'appiled_at': instance.appiled_at,
    };
