import 'package:hr_tool/riverpod/leaves/model/employee_leave_model.dart';
import 'package:hr_tool/riverpod/leaves/service/employee_leave_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'employee_leave_provider.g.dart';

@riverpod
Future<List<EmployeeLeaveModel>> EmployeeLeaveProvider(
  EmployeeLeaveProviderRef ref,
) async{
  return await EmployeeLeaveService().fetchLeaves();
}
