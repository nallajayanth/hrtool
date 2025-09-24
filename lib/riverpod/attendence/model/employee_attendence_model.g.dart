// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_attendence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAttendenceModel _$EmployeeAttendenceModelFromJson(
  Map<String, dynamic> json,
) => EmployeeAttendenceModel(
  id: json['id'] as String,
  user_id: json['user_id'] as String,
  status: json['status'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$EmployeeAttendenceModelToJson(
  EmployeeAttendenceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.user_id,
  'status': instance.status,
  'date': instance.date,
};
