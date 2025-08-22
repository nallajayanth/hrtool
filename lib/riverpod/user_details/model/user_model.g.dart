// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String,
  department: json['department'] as String,
  email: json['email'] as String,
  id: json['id'] as String,
  is_approved: json['is_approved'] as bool,
  mobile: (json['mobile'] as num).toInt(),
  role: json['role'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'department': instance.department,
  'is_approved': instance.is_approved,
  'mobile': instance.mobile,
  'id': instance.id,
};
