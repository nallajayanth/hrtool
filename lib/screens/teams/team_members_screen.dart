import 'package:flutter/material.dart';

class TeamMembersScreen extends StatelessWidget {
  const TeamMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Team Members Page")),
    );
  }
}

class LeaveRequestsScreen extends StatelessWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Leave Requests Page")),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Profile / Settings Page")),
    );
  }
}
