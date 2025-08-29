// lib/riverpod/performance/provider/performance_provider.dart
import 'package:hr_tool/riverpod/performance/model/performance_model.dart';
import 'package:hr_tool/riverpod/performance/service/performance_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'performance_provider.g.dart';

@riverpod
Future<List<PerformanceModel>> performanceList(PerformanceListRef ref, String userId) async {
  return await PerformanceService().fetchPerformance(userId);
}

@riverpod
Future<PerformanceModel> insertPerformance(InsertPerformanceRef ref, PerformanceModel performance) async {
  return await PerformanceService().insertPerformance(performance);
}
