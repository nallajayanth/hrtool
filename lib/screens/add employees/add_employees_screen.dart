// add_employees_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEmployeesScreen extends StatefulWidget {
  const AddEmployeesScreen({super.key});

  @override
  State<AddEmployeesScreen> createState() => _AddEmployeesScreenState();
}

class _AddEmployeesScreenState extends State<AddEmployeesScreen>
    with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  String? managerDepartment;
  String? managerId;
  bool loading = true;
  bool refreshing = false;

  List<Map<String, dynamic>> pendingEmployees = [];
  List<Map<String, dynamic>> approvedEmployees = [];

  // animation controllers
  late final AnimationController _approveController;
  late final AnimationController _rejectController;

  @override
  void initState() {
    super.initState();
    _approveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rejectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initialize();
  }

  @override
  void dispose() {
    _approveController.dispose();
    _rejectController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() => loading = true);
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      // not authenticated
      setState(() => loading = false);
      return;
    }

    managerId = currentUser.id;

    // fetch manager department
    final userInfo = await supabase
        .from('users')
        .select('department')
        .eq('id', managerId!)
        .maybeSingle();

    managerDepartment = userInfo?['department'] as String?;
    await _fetchAll();
  }

  Future<void> _fetchAll() async {
    if (managerDepartment == null) {
      setState(() => loading = false);
      return;
    }

    setState(() => loading = true);

    try {
      // Pending employees (is_approved = false)
      final pending = await supabase
          .from('users')
          .select('id, name, email, department, mobile')
          .eq('department', managerDepartment!)
          .eq('is_approved', false)
          .order('name', ascending: true);

      // Approved employees (is_approved = true)
      final approved = await supabase
          .from('users')
          .select('id, name, email, department, mobile')
          .eq('department', managerDepartment!)
          .eq('is_approved', true)
          .order('name', ascending: true);

      setState(() {
        pendingEmployees = List<Map<String, dynamic>>.from(pending);
        approvedEmployees = List<Map<String, dynamic>>.from(approved);
      });
    } catch (e) {
      debugPrint('Error fetching employees: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() => refreshing = true);
    await _fetchAll();
    setState(() => refreshing = false);
  }

  Future<void> _approveEmployee(Map<String, dynamic> emp) async {
    final empId = emp['id'] as String?;
    if (empId == null) return;

    final confirmed = await _confirmDialog(
      context,
      title: 'Approve Employee',
      content: 'Are you sure you want to approve ${emp['name']}?',
      confirmLabel: 'Approve',
    );
    if (!confirmed) return;

    // optimistic UI: remove from pending, add to approved
    setState(() {
      pendingEmployees.removeWhere((e) => e['id'] == empId);
      approvedEmployees.insert(0, {...emp, 'is_approved': true});
    });

    try {
      await supabase
          .from('users')
          .update({'is_approved': true})
          .eq('id', empId);

      // small animation
      _approveController.forward(from: 0);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${emp['name']} approved')));
    } catch (e) {
      // revert optimistic update on failure
      await _fetchAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${e.toString()}')),
      );
    }
  }

  Future<void> _rejectEmployee(Map<String, dynamic> emp) async {
    final empId = emp['id'] as String?;
    if (empId == null) return;

    final confirmed = await _confirmDialog(
      context,
      title: 'Reject Employee',
      content:
          'Rejecting will delete the registration from the system. Continue for ${emp['name']}?',
      confirmLabel: 'Reject',
    );
    if (!confirmed) return;

    // optimistic UI: remove from pending
    setState(() {
      pendingEmployees.removeWhere((e) => e['id'] == empId);
    });

    try {
      await supabase.from('users').delete().eq('id', empId);
      _rejectController.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${emp['name']} rejected and removed')),
      );
    } catch (e) {
      // revert on failure
      await _fetchAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${e.toString()}')),
      );
    }
  }

  Future<bool> _confirmDialog(
    BuildContext ctx, {
    required String title,
    required String content,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: ctx,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Team Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Approve or reject employee registrations',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _refresh,
            icon: refreshing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // placeholder search — you can plug in real search easily
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search employee name or email',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (q) {
          // quick client-side filter (optional enhancement)
        },
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp, {required bool pending}) {
    final name = emp['name'] ?? 'No name';
    final email = emp['email'] ?? '';
    final mobile = emp['mobile']?.toString() ?? '';
    final avatarLetter = (name.isNotEmpty) ? name[0].toUpperCase() : '?';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: pending
                  ? Colors.orange.shade50
                  : Colors.green.shade50,
              child: Text(
                avatarLetter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: pending
                      ? Colors.orange.shade800
                      : Colors.green.shade800,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(email, style: TextStyle(color: Colors.grey[700])),
                  if (mobile.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '📱 $mobile',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ],
              ),
            ),
            if (pending)
              Row(
                children: [
                  IconButton(
                    tooltip: 'Approve',
                    onPressed: () => _approveEmployee(emp),
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    iconSize: 30,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    tooltip: 'Reject',
                    onPressed: () => _rejectEmployee(emp),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    iconSize: 30,
                  ),
                ],
              )
            else
              IconButton(
                tooltip: 'Remove from team',
                onPressed: () async {
                  final confirmed = await _confirmDialog(
                    context,
                    title: 'Remove Employee',
                    content:
                        'Remove ${emp['name']} from the team? This will set is_approved=false.',
                    confirmLabel: 'Remove',
                  );
                  if (!confirmed) return;

                  final empId = emp['id'] as String?;
                  if (empId == null) return;

                  // optimistic remove from approved list
                  setState(() {
                    approvedEmployees.removeWhere((e) => e['id'] == empId);
                  });

                  try {
                    await supabase
                        .from('users')
                        .update({'is_approved': false})
                        .eq('id', empId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${emp['name']} removed from team'),
                      ),
                    );
                    await _fetchAll();
                  } catch (e) {
                    await _fetchAll();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Remove failed: ${e.toString()}')),
                    );
                  }
                },
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 6),

            // PENDING SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Pending Approvals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pendingEmployees.length.toString(),
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (pendingEmployees.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        final confirm = await _confirmDialog(
                          context,
                          title: 'Approve all',
                          content:
                              'Approve all pending employees? This will set is_approved=true for all pending.',
                          confirmLabel: 'Approve all',
                        );
                        if (!confirm) return;

                        try {
                          await _fetchAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All approved')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed: ${e.toString()}')),
                          );
                        }
                      },
                      child: const Text('Approve all'),
                    ),
                ],
              ),
            ),
            if (pendingEmployees.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No pending employees',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingEmployees.length,
                itemBuilder: (context, index) {
                  final emp = pendingEmployees[index];
                  return _employeeCard(emp, pending: true);
                },
              ),

            const SizedBox(height: 20),

            // APPROVED SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'Team Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      approvedEmployees.length.toString(),
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            if (approvedEmployees.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No team members yet',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: approvedEmployees.length,
                itemBuilder: (context, index) {
                  final emp = approvedEmployees[index];
                  return _employeeCard(emp, pending: false);
                },
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBodyContent(),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AddEmployeesScreen extends StatefulWidget {
//   const AddEmployeesScreen({Key? key}) : super(key: key);

//   @override
//   State<AddEmployeesScreen> createState() => _AddEmployeesScreenState();
// }

// class _AddEmployeesScreenState extends State<AddEmployeesScreen> {
//   final supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> pendingEmployees = [];
//   List<Map<String, dynamic>> approvedEmployees = [];
//   String? department;
//   String? managerId;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadEmployees();
//   }

//   Future<void> _loadEmployees() async {
//     setState(() => isLoading = true);

//     final currentUser = supabase.auth.currentUser;
//     if (currentUser == null) return;

//     // Get manager info
//     final managerData = await supabase
//         .from('users')
//         .select('id, department')
//         .eq('id', currentUser.id)
//         .maybeSingle();

//     if (managerData == null) return;

//     department = managerData['department'];
//     managerId = managerData['id'];

//     // Pending employees
//     final pendingData = await supabase
//         .from('users')
//         .select('id, name, email, department , role')
//         .eq('department', department!)
//         .eq('is_approved', false);

//     // Approved employees
//     final approvedData = await supabase
//         .from('users')
//         .select('id, name, email, department')
//         .eq('department', department!)
//         .eq('is_approved', true);

//     setState(() {
//       pendingEmployees = List<Map<String, dynamic>>.from(pendingData);
//       approvedEmployees = List<Map<String, dynamic>>.from(approvedData);
//       isLoading = false;
//     });
//   }

//   Future<void> _approveEmployee(String employeeId) async {
//     await supabase
//         .from('users')
//         .update({'is_approved': true, 'manager_id': managerId})
//         .eq('id', employeeId);

//     _loadEmployees();
//   }

//   Future<void> _rejectEmployee(String employeeId) async {
//     await supabase.from('users').delete().eq('id', employeeId);
//     _loadEmployees();
//   }

//   Widget _buildEmployeeCard(Map<String, dynamic> emp, bool isPending) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.teal.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12),
//         leading: CircleAvatar(
//           radius: 26,
//           backgroundColor: Colors.teal.shade100,
//           child: Text(
//             emp['name'] != null && emp['name'].isNotEmpty
//                 ? emp['name'][0].toUpperCase()
//                 : "?",
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.teal,
//             ),
//           ),
//         ),
//         title: Text(
//           emp['name'] ?? "No Name",
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Text(emp['email'] ?? "", style: TextStyle(color: Colors.grey[600])),
//             Container(
//               margin: const EdgeInsets.only(top: 4),
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.teal.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 emp['department'] ?? "",
//                 style: TextStyle(fontSize: 12, color: Colors.teal.shade800),
//               ),
//             ),
//           ],
//         ),
//         trailing: isPending
//             ? Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 28,
//                     ),
//                     onPressed: () => _approveEmployee(emp['id']),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
//                     onPressed: () => _rejectEmployee(emp['id']),
//                   ),
//                 ],
//               )
//             : const Icon(Icons.verified, color: Colors.teal, size: 28),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Employees"),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.teal,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _loadEmployees,
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Pending Section
//                     Text(
//                       "Pending Requests",
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     pendingEmployees.isEmpty
//                         ? const Text(
//                             "No pending employee requests",
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           )
//                         : Column(
//                             children: pendingEmployees
//                                 .map((emp) => _buildEmployeeCard(emp, true))
//                                 .toList(),
//                           ),
//                     const SizedBox(height: 24),

//                     // Approved Section
//                     Text(
//                       "Approved Employees",
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     approvedEmployees.isEmpty
//                         ? const Text(
//                             "No approved employees yet",
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           )
//                         : Column(
//                             children: approvedEmployees
//                                 .map((emp) => _buildEmployeeCard(emp, false))
//                                 .toList(),
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
