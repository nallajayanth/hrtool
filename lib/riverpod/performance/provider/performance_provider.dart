// // lib/riverpod/performance/provider/performance_provider.dart
// import 'package:hr_tool/riverpod/performance/model/performance_model.dart';
// import 'package:hr_tool/riverpod/performance/service/performance_service.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'performance_provider.g.dart';

// @riverpod
// Future<List<PerformanceModel>> performanceList(PerformanceListRef ref, String userId) async {
//   return await PerformanceService().fetchPerformance(userId);
// }

// @riverpod
// Future<PerformanceModel> insertPerformance(InsertPerformanceRef ref, PerformanceModel performance) async {
//   return await PerformanceService().insertPerformance(performance);
// }




// lib/riverpod/performance/provider/performance_provider.dart
import 'package:hr_tool/riverpod/performance/model/performance_model.dart';
import 'package:hr_tool/riverpod/performance/service/performance_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'performance_provider.g.dart';

/// Employee's performance reviews (by user_id)
@riverpod
Future<List<PerformanceModel>> performanceList(PerformanceListRef ref, String userId) async {
  return await PerformanceService().fetchPerformance(userId);
}

/// Manager's created performance reviews (by manager_id)
@riverpod
Future<List<PerformanceModel>> managerPerformanceList(ManagerPerformanceListRef ref, String managerId) async {
  return await PerformanceService().fetchManagerPerformances(managerId);
}

/// Insert a new performance record
@riverpod
Future<PerformanceModel> insertPerformance(InsertPerformanceRef ref, PerformanceModel performance) async {
  return await PerformanceService().insertPerformance(performance);
}

/// Update an existing performance record
@riverpod
Future<PerformanceModel> updatePerformance(UpdatePerformanceRef ref, PerformanceModel performance) async {
  return await PerformanceService().updatePerformance(performance);
}

/// Delete a performance record
@riverpod
Future<void> deletePerformance(DeletePerformanceRef ref, String performanceId) async {
  return await PerformanceService().deletePerformance(performanceId);
}