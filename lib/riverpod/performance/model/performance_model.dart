// lib/riverpod/performance/model/performance_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'performance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PerformanceModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'manager_id')
  final String managerId;
  final int? rating;
  final String? feedback;
  final String? achievements;
  final String? name;

  PerformanceModel({
    required this.id,
    required this.userId,
    required this.managerId,
    this.rating,
    this.feedback,
    this.achievements,
    this.name,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) =>
      _$PerformanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceModelToJson(this);
}