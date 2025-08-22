import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaveRequestsScreen extends ConsumerStatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  ConsumerState<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends ConsumerState<LeaveRequestsScreen> {
  final supabase = Supabase.instance.client;

  String? managerDepartment;
  bool loading = true;
  List<Map<String, dynamic>> processedLeaves = [];

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

    await _fetchProcessedLeaves();
  }

  Future<void> _fetchProcessedLeaves() async {
    if (managerDepartment == null) {
      setState(() => loading = false);
      return;
    }

    final requests = await supabase
        .from('leave')
        .select()
        .eq('department', managerDepartment!)
        .neq('status', 'Pending')
        .order('approved_at', ascending: false);

    setState(() {
      processedLeaves = List<Map<String, dynamic>>.from(
        requests as List<dynamic>,
      );
      loading = false;
    });
  }

  Future<void> _updateLeaveStatus(
    Map<String, dynamic> leave,
    String status,
  ) async {
    // Same Paid Leave limit logic
    if (status == "Approved" && (leave['leave_type'] == "Paid Leave")) {
      final paidLeavesTaken = await supabase
          .from('leave')
          .select()
          .eq('user_id', leave['user_id'])
          .eq('leave_type', 'Paid Leave')
          .eq('status', 'Approved');

      if ((paidLeavesTaken as List).length >= 2) {
        await supabase
            .from('leave')
            .update({
              'status': status,
              'leave_type': 'Unpaid Leave',
              'approved_at': DateTime.now().toIso8601String(),
            })
            .eq('id', leave['id']);
      } else {
        await supabase
            .from('leave')
            .update({
              'status': status,
              'approved_at': DateTime.now().toIso8601String(),
            })
            .eq('id', leave['id']);
      }
    } else {
      await supabase
          .from('leave')
          .update({
            'status': status,
            'approved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', leave['id']);
    }

    await _fetchProcessedLeaves();
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "On Hold":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("All Leave Requests"),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : processedLeaves.isEmpty
              ? const Center(child: Text("No processed leave requests yet."))
              : RefreshIndicator(
                  onRefresh: _fetchProcessedLeaves,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: processedLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = processedLeaves[index];
                      final status = leave['status'] ?? 'Unknown';
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.blue[100],
                                    child: const Icon(Icons.person, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 12),
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
                                    backgroundColor: _statusColor(status),
                                    labelStyle: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text("Type: ${leave['leave_type'] ?? ''}",
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text("Reason: ${leave['reason'] ?? ''}"),
                              Text(
                                "From: ${leave['start_date'] ?? ''}  To: ${leave['end_date'] ?? ''}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () => _updateLeaveStatus(leave, "Approved"),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () => _updateLeaveStatus(leave, "Rejected"),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.pause_circle, color: Colors.orange),
                                    onPressed: () => _updateLeaveStatus(leave, "On Hold"),
                                  ),
                                  const Spacer(),
                                  Text(
                                    leave['approved_at'] != null
                                        ? (leave['approved_at'] as String).split('T').first
                                        : '',
                                    style: const TextStyle(color: Colors.black45),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
