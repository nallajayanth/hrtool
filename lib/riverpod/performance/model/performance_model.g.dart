// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceModel _$PerformanceModelFromJson(Map<String, dynamic> json) =>
    PerformanceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      managerId: json['manager_id'] as String,
      rating: (json['rating'] as num?)?.toInt(),
      feedback: json['feedback'] as String?,
      achievements: json['achievements'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PerformanceModelToJson(PerformanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'manager_id': instance.managerId,
      'rating': instance.rating,
      'feedback': instance.feedback,
      'achievements': instance.achievements,
      'name': instance.name,
    };
