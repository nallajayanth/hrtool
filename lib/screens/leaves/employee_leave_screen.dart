import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeLeaveScreen extends StatefulWidget {
  const EmployeeLeaveScreen({super.key});

  @override
  State<EmployeeLeaveScreen> createState() => _EmployeeLeaveScreenState();
}

class _EmployeeLeaveScreenState extends State<EmployeeLeaveScreen> {
  final supabase = Supabase.instance.client;

  // Form fields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController reasonController = TextEditingController();
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  bool isSubmitting = false;

  List<Map<String, dynamic>> leaveRequests = [];
  List<String> leaveTypes = ['Sick Leave', 'Casual Leave', 'Paid Leave'];

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data = await supabase
        .from('leave')
        .select()
        .eq('user_id', userId)
        .order('appiled_at', ascending: false);

    setState(() {
      leaveRequests = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<DateTime?> _pickDate({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate() ||
        selectedLeaveType == null ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Get user info
      final userInfo = await supabase
          .from('users')
          .select('name, department')
          .eq('id', userId)
          .maybeSingle();

      final userName = userInfo?['name'];
      final userDepartment = userInfo?['department'];

      if (userName == null) throw Exception('User name not found');

      // Insert leave request
      await supabase.from('leave').insert({
        'user_id': userId,
        'name': userName,
        'leave_type': selectedLeaveType,
        'reason': reasonController.text.trim(),
        'start_date': DateFormat('yyyy-MM-dd').format(startDate!),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate!),
        'status': 'Pending',
        'appiled_at': DateTime.now().toIso8601String(),
        'department': userDepartment,
      });

      Navigator.pop(context); // close popup
      _fetchLeaveRequests(); // refresh list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave application submitted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void _openLeaveForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Apply for Leave",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Leave type
                      DropdownButtonFormField<String>(
                        value: selectedLeaveType,
                        decoration: const InputDecoration(
                          labelText: "Leave Type",
                          border: OutlineInputBorder(),
                        ),
                        items: leaveTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => selectedLeaveType = val),
                        validator: (val) =>
                            val == null ? 'Please select leave type' : null,
                      ),
                      const SizedBox(height: 12),

                      // Start date
                      ListTile(
                        title: Text(
                          startDate != null
                              ? "Start Date: ${DateFormat('dd MMM yyyy').format(startDate!)}"
                              : "Select Start Date",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await _pickDate(isStart: true);
                          if (picked != null) {
                            setModalState(() => startDate = picked);
                          }
                        },
                      ),

                      // End date
                      ListTile(
                        title: Text(
                          endDate != null
                              ? "End Date: ${DateFormat('dd MMM yyyy').format(endDate!)}"
                              : "Select End Date",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await _pickDate(isStart: false);
                          if (picked != null) {
                            setModalState(() => endDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Reason
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Reason",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Reason required'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Submit button
                      ElevatedButton.icon(
                        onPressed: isSubmitting ? null : _submitLeave,
                        icon: const Icon(Icons.send),
                        label: isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests"),
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLeaveRequests,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _openLeaveForm,
              child: Card(
                color: Colors.teal.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: const [
                      Icon(Icons.add_circle, color: Colors.teal, size: 28),
                      SizedBox(width: 12),
                      Text(
                        "Apply for Leave",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "My Leave Requests",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (leaveRequests.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    "No leave requests found",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...leaveRequests.map((leave) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      leave['leave_type'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${leave['start_date']} → ${leave['end_date']}\n${leave['reason']}",
                    ),
                    trailing: Text(
                      leave['status'] ?? 'Pending',
                      style: TextStyle(
                        color: _statusColor(leave['status'] ?? 'Pending'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
