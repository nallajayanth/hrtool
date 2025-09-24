import 'package:hr_tool/riverpod/task/model/task_model.dart';
import 'package:hr_tool/riverpod/task/service/task_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_provider.g.dart';

/// Manager's Task Provider
@riverpod
Future<List<TaskModel>> taskProvider(TaskProviderRef ref) async {
  return await TaskService.fetchManagerTasks();
}

/// Employee's Task Provider
@riverpod
Future<List<TaskModel>> employeeTaskProvider(EmployeeTaskProviderRef ref) async {
  return await TaskService.fetchEmployeeTasks();
}
