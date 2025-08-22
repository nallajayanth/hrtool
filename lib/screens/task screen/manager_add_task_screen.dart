// manager_add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hr_tool/riverpod/employee%20list%20provider/employee_list_provider.dart';

class ManagerAddTaskScreen extends ConsumerStatefulWidget {
  const ManagerAddTaskScreen({super.key});

  @override
  ConsumerState<ManagerAddTaskScreen> createState() =>
      _ManagerAddTaskScreenState();
}

class _ManagerAddTaskScreenState extends ConsumerState<ManagerAddTaskScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  // UI state for search & layout
  String _searchQuery = '';
  bool _isGrid = false;

  // Helper to refresh provider
  Future<void> _refreshEmployees() async {
    // Re-fetch the employee provider; adjust the provider name if different
    ref.refresh(employeeListProvider);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Open assign task bottom sheet for a specific employee
  void _openAssignTaskSheet(Map<String, dynamic> employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignTaskSheet(
        employee: employee,
        onAssigned: () {
          // refresh on success
          _refreshEmployees();
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Assign Tasks',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            tooltip: 'Toggle layout',
            onPressed: () => setState(() => _isGrid = !_isGrid),
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refreshEmployees,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search employees...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (s) => setState(() => _searchQuery = s.trim().toLowerCase()),
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp) {
    final name = (emp['name'] ?? 'Unknown') as String;
    final role = (emp['role'] ?? 'Employee') as String;
    final dept = (emp['department'] ?? '') as String;
    final mobile = (emp['mobile']?.toString() ?? '');
    final id = emp['id'] as String?;
    final avatarLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;

        final info = Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade50,
              child: Text(
                avatarLetter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$role • $dept',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  if (mobile.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '📱 $mobile',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

        final buttonRow = Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_task),
                label: const Text('Assign Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _openAssignTaskSheet(emp),
              ),
            ),
          ],
        );

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: hasBoundedHeight
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                if (hasBoundedHeight) const Spacer(),
                const SizedBox(height: 12),
                buttonRow,
                if (!hasBoundedHeight) ...[], // No extra for min
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeeListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Team Tasks'),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSearchField(),
            const SizedBox(height: 12),
            Expanded(
              child: employeesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data: (employees) {
                  // employees is expected to be List<Map>
                  final list = (employees as List)
                      .cast<Map<String, dynamic>>()
                      .where((e) {
                        final name = (e['name'] ?? '').toString().toLowerCase();
                        final email = (e['email'] ?? '')
                            .toString()
                            .toLowerCase();
                        final dept = (e['department'] ?? '')
                            .toString()
                            .toLowerCase();
                        if (_searchQuery.isEmpty) return true;
                        return name.contains(_searchQuery) ||
                            email.contains(_searchQuery) ||
                            dept.contains(_searchQuery);
                      })
                      .toList();

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No employees found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          TextButton.icon(
                            onPressed: _refreshEmployees,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Grid or List layout
                  if (_isGrid) {
                    return RefreshIndicator(
                      onRefresh: _refreshEmployees,
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: list.length,
                        itemBuilder: (_, i) => _employeeCard(list[i]),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshEmployees,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (_, i) {
                          final emp = list[i];
                          return _employeeCard(emp);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet widget for creating a task for a given employee.
/// This is kept as a separate StatefulWidget so it can manage its own form/loading state.
class _AssignTaskSheet extends StatefulWidget {
  final Map<String, dynamic> employee;
  final VoidCallback? onAssigned;

  const _AssignTaskSheet({required this.employee, this.onAssigned});

  @override
  State<_AssignTaskSheet> createState() => _AssignTaskSheetState();
}

class _AssignTaskSheetState extends State<_AssignTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dueDate;
  bool _loading = false;

  final supabase = Supabase.instance.client;

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // manager info
      final manager = supabase.auth.currentUser;
      if (manager == null) throw 'Manager not authenticated';

      final managerProfile = await supabase
          .from('users')
          .select('name')
          .eq('id', manager.id)
          .maybeSingle();

      final managerName = managerProfile?['name'] ?? '';

      // Prepare payload
      final payload = {
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'due_date': _dueDate!.toIso8601String(),
        'status': 'pending',
        'employee_id': widget.employee['id'],
        'employee_name': widget.employee['name'],
        'manager_id': manager.id,
        'manager_name': managerName,
        'created_at': DateTime.now().toIso8601String(),
        'is_completed': false,
      };

      await supabase.from('tasks').insert(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task assigned successfully')),
      );

      widget.onAssigned?.call();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to assign task: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;
    final name = emp['name'] ?? 'Unknown';
    final dept = emp['department'] ?? '';

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.45,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.teal.shade50,
                      child: Text(
                        (name.isNotEmpty ? name[0].toUpperCase() : '?'),
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(dept, style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    Text(
                      'Assign Task',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Task Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        minLines: 3,
                        maxLines: 5,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        onTap: _pickDueDate,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        title: Text(
                          _dueDate == null
                              ? 'Select due date'
                              : 'Due ${DateFormat.yMMMd().format(_dueDate!)}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            _loading ? 'Assigning...' : 'Assign Task',
                          ),
                          onPressed: _loading ? null : _submitTask,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
