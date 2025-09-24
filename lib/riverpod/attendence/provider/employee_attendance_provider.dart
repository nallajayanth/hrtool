import 'package:hr_tool/riverpod/attendence/model/employee_attendence_model.dart';
import 'package:hr_tool/riverpod/attendence/service/employee_attendance_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'employee_attendance_provider.g.dart';
@riverpod 
Future<List<EmployeeAttendenceModel>> EmployeeAttendanceProvider(EmployeeAttendanceProviderRef ref ) async {
  return await EmployeeAttendanceService.fetchAttendence();
}
