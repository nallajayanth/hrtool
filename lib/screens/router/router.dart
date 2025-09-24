import 'package:go_router/go_router.dart';
import 'package:hr_tool/screens/add%20employees/add_employees_screen.dart';
import 'package:hr_tool/screens/attendence/employee_attendence.dart';
import 'package:hr_tool/screens/attendence/manager_attendance_overview.dart';
import 'package:hr_tool/screens/auth/login_screen.dart';
import 'package:hr_tool/screens/auth/register_screen.dart';
import 'package:hr_tool/screens/home%20screen/employee_home_screen.dart';
import 'package:hr_tool/screens/home%20screen/manager_home_screen.dart';
import 'package:hr_tool/screens/leaves/employee_leave_screen.dart';
import 'package:hr_tool/screens/leaves/leave_requests_screen.dart';
import 'package:hr_tool/screens/performance%20screens/employee_performance_screen.dart';
import 'package:hr_tool/screens/performance%20screens/manager_add_performance_screen.dart';
import 'package:hr_tool/screens/profiles/profile_screen.dart';
import 'package:hr_tool/screens/splash_screen.dart';
import 'package:hr_tool/screens/task%20screen/employee_task_screen.dart';
import 'package:hr_tool/screens/task%20screen/manager_add_task_screen.dart';
import 'package:hr_tool/screens/task%20screen/view_assigned_tasks_screen.dart';
import 'package:hr_tool/screens/teams/employees_team_members_screen.dart';

import 'manager_main_scaffold.dart';
import 'employee_main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    // --- Auth & Splash ---
    GoRoute(path: "/", builder: (context, state) => SplashScreen()),
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),

    // --- Standalone routes (no bottom nav) ---
    GoRoute(
      path: "/employee-performance-screen",
      builder: (context, state) => EmployeePerformanceScreen(),
    ),
    GoRoute(
      path: '/view-assigned-tasks',
      builder: (context, state) => ViewAssignedTasksScreen(),
    ),
    GoRoute(
      path: "/manager-add-performance",
      builder: (context, state) => ManagerAddPerformanceScreen(),
    ),
    GoRoute(
      path: "/manager-attendance",
      builder: (context, state) => ManagerAttendanceOverview(),
    ),
    GoRoute(
      path: "/empolyee-attendance",
      builder: (context, state) => EmployeeAttendanceScreen(),
    ),
    GoRoute(
      path: "/manager-add-task",
      builder: (context, state) => ManagerAddTaskScreen(),
    ),
    GoRoute(
      path: "/add-employees",
      builder: (context, state) => AddEmployeesScreen(),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfileScreen(),
    ),


    // --- Employee ShellRoute ---
    ShellRoute(
      builder: (context, state, child) {
        return EmployeeMainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: "/employee-home",
          builder: (context, state) {
            return EmployeeHomeScreen();
          },
        ),
        GoRoute(
          path: "/employee-attendance",
          builder: (context, state) => EmployeeAttendanceScreen(),
        ),
        GoRoute(
          path: "/employee-leave",
          builder: (context, state) => EmployeeLeaveScreen(),
        ),
        GoRoute(
          path: "/employees-team-members",
          builder: (context, state) => EmployeesTeamMembersScreen(),
        ),
        GoRoute(
          path: "/employee-task",
          builder: (context, state) => EmployeeTasksScreen(),
        ),
        GoRoute(
          path: "/employee-profile",
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // --- Manager ShellRoute ---
    ShellRoute(
      builder: (context, state, child) {
        return ManagerMainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: "/manager-home",
          builder: (context, state) => ManagerHomeScreen(),
        ),
        GoRoute(
          path: "/team",
          builder: (context, state) => AddEmployeesScreen(),
        ),
        GoRoute(
          path: "/leave-request",
          builder: (context, state) => LeaveRequestsScreen(),
        ),
        GoRoute(
          path: "/manager-profile",
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
