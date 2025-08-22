// lib/screens/tasks/employee_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hr_tool/riverpod/task/model/task_model.dart';
import 'package:hr_tool/riverpod/task/service/task_service.dart';
import 'package:hr_tool/riverpod/task/provider/task_provider.dart';

class EmployeeTasksScreen extends ConsumerStatefulWidget {
  const EmployeeTasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EmployeeTasksScreen> createState() =>
      _EmployeeTasksScreenState();
}

class _EmployeeTasksScreenState extends ConsumerState<EmployeeTasksScreen> {
  bool _busy = false;

  Future<void> _refresh() async {
    // invalidate provider so it refetches
    ref.invalidate(employeeTaskProviderProvider);
  }

  Color _statusColor(String? status) {
    if (status == null) return Colors.blueGrey;
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade700;
      case 'in-progress':
      case 'in progress':
        return Colors.orange.shade700;
      case 'pending':
      default:
        return Colors.blueGrey;
    }
  }

  IconData _statusIcon(String? status) {
    if (status == null) return Icons.schedule;
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in-progress':
      case 'in progress':
        return Icons.autorenew;
      case 'pending':
      default:
        return Icons.schedule;
    }
  }

  Future<void> _updateStatus(String taskId, String newStatus) async {
    setState(() => _busy = true);
    try {
      await TaskService.updateTaskStatus(taskId: taskId, newStatus: newStatus);
      // refresh provider
      ref.invalidate(employeeTaskProviderProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task marked as "$newStatus"')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showStatusMenu(TaskModel task) async {
    final choice = await showModalBottomSheet<String?>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Mark Pending'),
                onTap: () => Navigator.of(ctx).pop('pending'),
              ),
              ListTile(
                leading: const Icon(Icons.autorenew),
                title: const Text('Mark In-Progress'),
                onTap: () => Navigator.of(ctx).pop('in-progress'),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Mark Completed'),
                onTap: () => Navigator.of(ctx).pop('completed'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (choice != null && choice != (task.status)) {
      await _updateStatus(task.id, choice);
    }
  }

  Widget _buildHeaderCounts(List<TaskModel> tasks) {
    final total = tasks.length;
    final completed = tasks
        .where((t) => (t.status).toLowerCase() == 'completed')
        .length;
    final inProgress = tasks.where((t) {
      final s = (t.status).toLowerCase();
      return s == 'in-progress' || s == 'in progress';
    }).length;
    final pending = tasks
        .where((t) => (t.status).toLowerCase() == 'pending')
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(child: _statCard('Total', total.toString(), Colors.indigo)),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard('Pending', pending.toString(), Colors.blueGrey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _statCard(
              'In-Progress',
              inProgress.toString(),
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard('Completed', completed.toString(), Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.95), color.withOpacity(0.75)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.14),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(TaskModel task) {
    // due_date might be DateTime or string in model. handle both gracefully.
    DateTime? due;
    if (task.due_date is DateTime) {
      due = task.due_date as DateTime;
    } else if (task.due_date is String) {
      try {
        due = DateTime.parse(task.due_date as String);
      } catch (_) {
        due = null;
      }
    } else {
      due = null;
    }

    final dueText = due != null ? DateFormat.yMMMd().format(due) : 'No due';
    final daysLeft = due != null ? due.difference(DateTime.now()).inDays : 9999;
    final isOverdue =
        (daysLeft < 0) && (task.status).toLowerCase() != 'completed';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showDialog(
          context: context,
          builder: (_) => _taskDetailDialog(task),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Left status icon block
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _statusColor(task.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _statusIcon(task.status),
                  color: _statusColor(task.status),
                  size: 30,
                ),
              ),

              const SizedBox(width: 12),

              // Main flexible content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Bottom row with chips and manager
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          backgroundColor: isOverdue
                              ? Colors.red.shade50
                              : Colors.grey.shade100,
                          avatar: Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: isOverdue ? Colors.red : Colors.grey[700],
                          ),
                          label: Text(
                            dueText,
                            style: TextStyle(
                              color: isOverdue ? Colors.red : Colors.grey[800],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'By: ${task.manager_name}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        // Status pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(task.status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (task.status).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              color: _statusColor(task.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 46,
                        maxWidth: 120,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _showStatusMenu(task),
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Change status',
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _statusColor(task.status),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  (task.status).toLowerCase() == 'completed'
                                  ? null
                                  : () => _updateStatus(task.id, 'completed'),
                              child: Text(
                                (task.status).toLowerCase() == 'completed'
                                    ? 'Done'
                                    : 'Complete',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskDetailDialog(TaskModel task) {
    DateTime? due;
    {
      try {
        due = DateTime.parse(task.due_date as String);
      } catch (_) {
        due = null;
      }
    }

    final dueText = due != null
        ? DateFormat.yMMMMd().format(due)
        : 'No due date';

    return AlertDialog(
      title: Text(task.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 8),
              Text('Manager: ${task.manager_name}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text('Due: $dueText'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Text('Status: ${task.status}'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: (task.status).toLowerCase() == 'completed'
              ? null
              : () {
                  Navigator.pop(context);
                  _updateStatus(task.id, 'completed');
                },
          child: const Text('Mark Completed'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(employeeTaskProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading tasks: $err')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Icon(Icons.task_alt, size: 88, color: Colors.grey),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'No tasks yet',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'When your manager assigns tasks they will appear here.',
                    ),
                  ),
                ],
              ),
            );
          }

          // sort by due date (nulls pushed to end)
          tasks.sort((a, b) {
            DateTime? da;
            DateTime? db;
            try {
              da = DateTime.parse(a.due_date as String);
            } catch (_) {
              da = null;
            }
            try {
              db = DateTime.parse(b.due_date as String);
            } catch (_) {
              db = null;
            }
            if (da == null && db == null) return 0;
            if (da == null) return 1;
            if (db == null) return -1;
            return da.compareTo(db);
          });

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                _buildHeaderCounts(tasks),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Assigned Tasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 6),
                for (final t in tasks) _taskCard(t),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.deepPurple,
      //   onPressed: () {
      //     ScaffoldMessenger.of(
      //       context,
      //     ).showSnackBar(const SnackBar(content: Text('No action configured')));
      //   },
      //   icon: const Icon(Icons.filter_list),
      //   label: const Text('Filters'),
      // ),
    );
  }
}
