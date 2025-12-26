import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hr_tool/riverpod/user_details/provider/user_provider.dart';

class EmployeeHomeScreen extends ConsumerStatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  ConsumerState<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends ConsumerState<EmployeeHomeScreen> {
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  String? checkInTime;
  String? checkOutTime;
  String? name;

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
  }

  Future<void> _loadAttendanceStatus() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await supabase
        .from('attendance')
        .select()
        .eq('user_id', userId)
        .eq('date', today)
        .maybeSingle();

    if (response != null) {
      setState(() {
        if (response['check_in'] != null) {
          DateTime parsedCheckIn = DateTime.parse(response['check_in']);
          isCheckedIn = true;
          checkInTime = DateFormat('hh:mm a').format(parsedCheckIn);
        }
        if (response['check_out'] != null) {
          DateTime parsedCheckOut = DateTime.parse(response['check_out']);
          isCheckedOut = true;
          checkOutTime = DateFormat('hh:mm a').format(parsedCheckOut);
        }
      });
    }
  }

  Future<void> _checkIn() async {
    final supabase = Supabase.instance.client;
    final now = DateTime.now();
    final userId = supabase.auth.currentUser!.id;
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final existing = await supabase
        .from('attendance')
        .select()
        .eq('user_id', userId)
        .eq('date', formattedDate)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('attendance').insert({
        'user_id': userId,
        'date': formattedDate,
        'status': 'Present',
        'check_in': now.toIso8601String(),
        'name': name,
      });

      setState(() {
        isCheckedIn = true;
        checkInTime = DateFormat('hh:mm a').format(now);
      });
    }
  }

  Future<void> _checkOut() async {
    final supabase = Supabase.instance.client;
    final now = DateTime.now();
    final userId = supabase.auth.currentUser!.id;
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    await supabase
        .from('attendance')
        .update({'check_out': now.toIso8601String()})
        .eq('user_id', userId)
        .eq('date', formattedDate);

    setState(() {
      isCheckedOut = true;
      isCheckedIn = false;
      checkOutTime = DateFormat('hh:mm a').format(now);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked out at ${DateFormat('hh:mm a').format(now)}'),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,

    Color? color,
    GestureTapCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: (color ?? Colors.blue).withOpacity(0.1),
              radius: 24,
              child: Icon(icon, color: color ?? Colors.blue, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProviderProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: userAsyncValue.when(
          data: (users) {
            final user = users.isNotEmpty ? users[0] : null;
            name = user?.name;
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    context.push('/profile');
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? "Loading...",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${user?.role ?? "Employee"} - ${user?.department ?? ""}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Text("Loading..."),
          error: (err, _) => const Text("Error loading user"),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // This Week Section
            const Text(
              "This Week",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(6, (index) {
                final date = DateTime.now().subtract(
                  Duration(days: DateTime.now().weekday - 1 - index),
                );
                final label = DateFormat('E').format(date);
                final day = date.day.toString();
                final isToday = date.day == DateTime.now().day;
                return Column(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isToday ? Colors.blue : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 22),

            // Attendance Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.access_time, size: 40, color: Colors.blue),
                  const SizedBox(height: 10),
                  Text(
                    "Check-In: ${checkInTime ?? "Not yet"}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    "Check-Out: ${checkOutTime ?? "Not yet"}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: isCheckedIn
                          ? Colors.redAccent
                          : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isCheckedOut
                        ? null
                        : (isCheckedIn ? _checkOut : _checkIn),
                    child: Text(
                      isCheckedIn ? "Check-Out" : "Check-In",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.push('/empolyee-attendance');
                    },
                    child: const Text("View Your Attendance"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.task,
                    title: "Task",
                    onTap: () => context.push("/employee-task"),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_today,
                    title: "Performance",
                    onTap: () => context.push("/employee-performance-screen"),

                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.beach_access,
                    title: "Apply Leave",
                    color: Colors.teal,
                    onTap: () => context.push("/employee-leave"),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.group_rounded,
                    title: "Team Members",
                    color: Colors.blue,
                    onTap: () => context.push("/employees-team-members"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
