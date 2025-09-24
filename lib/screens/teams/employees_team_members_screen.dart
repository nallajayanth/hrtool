import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class EmployeesTeamMembersScreen extends StatefulWidget {
  const EmployeesTeamMembersScreen({super.key});

  @override
  State<EmployeesTeamMembersScreen> createState() =>
      _EmployeesTeamMembersScreenState();
}

class _EmployeesTeamMembersScreenState
    extends State<EmployeesTeamMembersScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> teamMembers = [];
  List<Map<String, dynamic>> filteredMembers = [];
  bool isLoading = true;
  String searchQuery = "";
  String? errorMessage;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadTeamMembers();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadTeamMembers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        setState(() {
          errorMessage = "Please log in to view team members";
          isLoading = false;
        });
        return;
      }

      // Get employee's department
      final employeeData = await supabase
          .from('users')
          .select('department')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (employeeData == null || employeeData['department'] == null) {
        setState(() {
          errorMessage = "Unable to load department information";
          isLoading = false;
        });
        return;
      }

      final department = employeeData['department'];

      // Fetch all approved employees in the same department (excluding self)
      final membersData = await supabase
          .from('users')
          .select('id, name, email, mobile, role, department')
          .eq('department', department)
          .neq('id', currentUser.id)
          .eq('is_approved', true);

      setState(() {
        teamMembers = List<Map<String, dynamic>>.from(membersData);
        filteredMembers = teamMembers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error loading team members: $e";
        isLoading = false;
      });
    }
  }

  void _filterMembers(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        filteredMembers = teamMembers
            .where(
              (member) =>
                  (member['name']?.toLowerCase() ?? '').contains(
                    query.toLowerCase(),
                  ) ||
                  (member['role']?.toLowerCase() ?? '').contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      });
    });
  }


  Widget _buildMemberCard(Map<String, dynamic> member) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.teal.shade100,
          child: Text(
            member['name']?.isNotEmpty == true
                ? member['name'][0].toUpperCase()
                : "?",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          member['name'] ?? "No Name",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (member['role'] != null)
              Text(member['role'], style: TextStyle(color: Colors.grey[700])),
            if (member['email'] != null)
              Text(
                member['email'],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            if (member['mobile'] != null)
              Text(
                member['mobile'].toString(), // Convert int to string
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Team Members"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTeamMembers,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: _filterMembers,
                      decoration: InputDecoration(
                        hintText: "Search team members...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredMembers.isEmpty
                        ? const Center(
                            child: Text(
                              "No team members found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredMembers.length,
                            itemBuilder: (context, index) {
                              return _buildMemberCard(filteredMembers[index]);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
