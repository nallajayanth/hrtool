import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'employee_list_provider.g.dart';

@riverpod
Future<List<Map<String, dynamic>>> employeeList(EmployeeListRef ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser!;

  // Fetch employees in same department as manager
  final profile = await supabase
      .from('users')
      .select('department')
      .eq('id', user.id)
      .single();

  final department = profile['department'];

  final employees = await supabase
      .from('users')
      .select('id, name')
      .eq('department', department)
      .eq('role', 'Employee'); // only employees

  return employees;
}
