import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class EmployeeMainScaffold extends StatefulWidget {
  final Widget child;
  const EmployeeMainScaffold({super.key, required this.child});

  @override
  State<EmployeeMainScaffold> createState() => _EmployeeMainScaffoldState();
}

class _EmployeeMainScaffoldState extends State<EmployeeMainScaffold> {
  // Tabs for employee bottom nav
  final tabs = [
    '/employee-home',
    '/employee-attendance',
    '/employee-task',
    '/employees-team-members',
    '/employee-profile',
  ];

  int get _currentIndex {
    final location = GoRouterState.of(context).uri.path;
    final index = tabs.indexOf(location);
    return index >= 0 ? index : 0;
  }

  void _onTap(int index) {
    context.go(tabs[index]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20), 
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available_rounded),
                label: 'Attendance',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_rounded),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_rounded),
                label: 'Team',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
