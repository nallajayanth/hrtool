// // lib/riverpod/performance/service/performance_service.dart
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../model/performance_model.dart';

// class PerformanceService {
//   final _client = Supabase.instance.client;

//   /// Insert a new performance record
//   Future<PerformanceModel> insertPerformance(PerformanceModel performance) async {
//     final response = await _client
//         .from('performance')
//         .insert(performance.toJson())
//         .select()
//         .single();

//     return PerformanceModel.fromJson(response);
//   }

//   /// Fetch all performance records (e.g. for a user)
//   Future<List<PerformanceModel>> fetchPerformance(String userId) async {
//     final response = await _client
//         .from('performance')
//         .select()
//         .eq('user_id', userId);

//     return (response as List)
//         .map((e) => PerformanceModel.fromJson(e))
//         .toList();
//   }
// }



// lib/riverpod/performance/service/performance_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/performance_model.dart';

class PerformanceService {
  final _client = Supabase.instance.client;

  /// Insert a new performance record
  Future<PerformanceModel> insertPerformance(PerformanceModel performance) async {
    final response = await _client
        .from('performance')
        .insert(performance.toJson())
        .select()
        .single();

    return PerformanceModel.fromJson(response);
  }

  /// Fetch all performance records for an employee (by user_id)
  Future<List<PerformanceModel>> fetchPerformance(String userId) async {
    final response = await _client
        .from('performance')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => PerformanceModel.fromJson(e))
        .toList();
  }

  /// Fetch all performance records created by a manager (by manager_id)
  Future<List<PerformanceModel>> fetchManagerPerformances(String managerId) async {
    final response = await _client
        .from('performance')
        .select()
        .eq('manager_id', managerId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => PerformanceModel.fromJson(e))
        .toList();
  }

  /// Update an existing performance record
  Future<PerformanceModel> updatePerformance(PerformanceModel performance) async {
    final response = await _client
        .from('performance')
        .update(performance.toJson())
        .eq('id', performance.id)
        .select()
        .single();

    return PerformanceModel.fromJson(response);
  }

  /// Delete a performance record
  Future<void> deletePerformance(String performanceId) async {
    await _client
        .from('performance')
        .delete()
        .eq('id', performanceId);
  }
}