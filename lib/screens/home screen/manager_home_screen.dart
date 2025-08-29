// manager_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManagerHomeScreen extends ConsumerStatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  ConsumerState<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends ConsumerState<ManagerHomeScreen> {
  final supabase = Supabase.instance.client;

  String? managerDepartment;
  bool loading = true;
  List<Map<String, dynamic>> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchManagerData();
  }

  Future<void> _fetchManagerData() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final userInfo = await supabase
        .from('users')
        .select('department')
        .eq('id', userId)
        .maybeSingle();

    setState(() {
      managerDepartment = userInfo?['department'] as String?;
    });

    await _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    if (managerDepartment == null) {
      setState(() => loading = false);
      return;
    }

    final requests = await supabase
        .from('leave')
        .select()
        .eq('department', managerDepartment!)
        .eq('status', 'Pending')
        .order('appiled_at', ascending: false);

    setState(() {
      leaveRequests = List<Map<String, dynamic>>.from(
        requests as List<dynamic>,
      );
      loading = false;
    });
  }

  Future<void> _updateLeaveStatus(
    Map<String, dynamic> leave,
    String status,
  ) async {
    if (status == "Approved" && (leave['leave_type'] == "Paid Leave")) {
      // Check how many paid leaves are already approved
      final paidLeavesTaken = await supabase
          .from('leave')
          .select()
          .eq('user_id', leave['user_id'])
          .eq('leave_type', 'Paid Leave')
          .eq('status', 'Approved');

      if ((paidLeavesTaken as List).length >= 2) {
        // Change to unpaid leave if limit reached
        await supabase
            .from('leave')
            .update({
              'status': status,
              'leave_type': 'Unpaid Leave',
              'approved_at': DateTime.now().toIso8601String(),
            })
            .eq('id', leave['id']);
      } else {
        // Approve as paid leave
        await supabase
            .from('leave')
            .update({
              'status': status,
              'approved_at': DateTime.now().toIso8601String(),
            })
            .eq('id', leave['id']);
      }
    } else {
      // Normal approval/rejection/on-hold
      await supabase
          .from('leave')
          .update({
            'status': status,
            'approved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', leave['id']);
    }

    await _fetchLeaveRequests();
  }

  Widget _buildQuickActions() {
    final actions = [
      {"title": "Add Task", "icon": Icons.task, "color": Colors.blue},
      {
        "title": "Leave Requests",
        "icon": Icons.event_note,
        "color": Colors.orange,
      },
      {
        "title": "Add Performance",
        "icon": Icons.trending_up,
        "color": Colors.green,
      },
      {"title": "Attendance", "icon": Icons.bar_chart, "color": Colors.purple},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 1) {
              context.push("/leave-request");
            } else if (index == 0) {
              context.push("/manager-add-task");
            }
             else if (index == 2) {
              context.push("/manager-add-performance");
            }
            else if (index == 3) {
              context.push("/manager-attendance");
            }

          },
          child: Container(
            decoration: BoxDecoration(
              color: actions[index]['color'] as Color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  actions[index]['icon'] as IconData,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  actions[index]['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaveRequests() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (leaveRequests.isEmpty) {
      return const Center(child: Text("No leave requests found."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaveRequests.length,
      itemBuilder: (context, index) {
        final leave = leaveRequests[index];
        final status = (leave['status'] ?? 'Pending') as String;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        leave['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(status),
                      backgroundColor: status == "Approved"
                          ? Colors.green
                          : status == "Rejected"
                          ? Colors.red
                          : Colors.orange,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Type: ${leave['leave_type'] ?? ''}"),
                Text("Reason: ${leave['reason'] ?? ''}"),
                Text(
                  "From: ${leave['start_date'] ?? ''}  To: ${leave['end_date'] ?? ''}",
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _updateLeaveStatus(leave, "Approved"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _updateLeaveStatus(leave, "Rejected"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause_circle, color: Colors.grey),
                      onPressed: () => _updateLeaveStatus(leave, "On Hold"),
                    ),
                    const Spacer(),
                    Text(
                      leave['appiled_at'] != null
                          ? (leave['appiled_at'] as String).split('T').first
                          : '',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text("Manager Dashboard"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLeaveRequests,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildQuickActions(),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Leave Requests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildLeaveRequests(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
