import 'package:hr_tool/riverpod/attendence/model/employee_attendence_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeAttendanceService {

  static Future<List<EmployeeAttendenceModel>> fetchAttendence() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser!;
    final response = await supabase
        .from("attendance")
        .select()
        .eq("user_id", user.id); 

    return (response as List)
        .map((item) => EmployeeAttendenceModel.fromJson(item))
        .toList();
  }
}
   