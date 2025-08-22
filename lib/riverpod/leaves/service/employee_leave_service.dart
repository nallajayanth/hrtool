import 'package:hr_tool/riverpod/leaves/model/employee_leave_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeLeaveService {
  Future<List<EmployeeLeaveModel>> fetchLeaves() async {
    final supabse = Supabase.instance.client;

    final response = await supabse
        .from("leave")
        .select()
        .eq('status', 'Pending');

    return (response as List)
        .map((items) => EmployeeLeaveModel.fromJson(items))
        .toList();
  }
}
