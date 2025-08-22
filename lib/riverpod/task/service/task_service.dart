import 'package:hr_tool/riverpod/task/model/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  /// Manager - Fetch all tasks they created
  static Future<List<TaskModel>> fetchManagerTasks() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser!;

    final response = await supabase
        .from("tasks")
        .select()
        .eq("manager_id", user.id);

    return (response as List).map((item) => TaskModel.fromJson(item)).toList();
  }

  /// Employee - Fetch all tasks assigned to them
  static Future<List<TaskModel>> fetchEmployeeTasks() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser!;

    final response = await supabase
        .from("tasks")
        .select()
        .eq("employee_id", user.id);

    return (response as List).map((item) => TaskModel.fromJson(item)).toList();
  }

  /// Manager - Add a new task
  static Future<void> addTask({
    required String title,
    required String description,
    required String employeeId,
    required String employeeName,
    required DateTime dueDate,
  }) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser!;

    await supabase.from("tasks").insert({
      "title": title,
      "description": description,
      "employee_id": employeeId,
      "employee_name": employeeName,
      "manager_id": user.id,
      "manager_name": user.userMetadata?['full_name'] ?? 'Manager',
      "status": "pending",
      "due_date": dueDate.toIso8601String(),
    });
  }

  /// Employee - Update task status
  static Future<void> updateTaskStatus({
    required String taskId,
    required String newStatus,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from("tasks").update({"status": newStatus}).eq("id", taskId);
  }
}
