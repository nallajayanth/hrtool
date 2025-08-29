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

  /// Fetch all performance records (e.g. for a user)
  Future<List<PerformanceModel>> fetchPerformance(String userId) async {
    final response = await _client
        .from('performance')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((e) => PerformanceModel.fromJson(e))
        .toList();
  }
}
