// import 'package:go_router/go_router.dart';
// import 'package:hr_tool/screens/add%20employees/add_employees_screen.dart';
// import 'package:hr_tool/screens/attendence/employee_attendence.dart';
// import 'package:hr_tool/screens/auth/login_screen.dart';
// import 'package:hr_tool/screens/auth/register_screen.dart';
// import 'package:hr_tool/screens/home%20screen/employee_home_screen.dart';
// import 'package:hr_tool/screens/home%20screen/manager_home_screen.dart';
// import 'package:hr_tool/screens/leaves/employee_leave_screen.dart';
// import 'package:hr_tool/screens/leaves/leave_requests_screen.dart';

// import 'package:hr_tool/screens/splash_screen.dart';

// final appRouter = GoRouter(
//   initialLocation: "/",
//   routes: [
//     GoRoute(path: "/", builder: (context, state) => SplashScreen()),
//     GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
//     GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
//     GoRoute(
//       path: "/employee-home",
//       builder: (context, state) {
//         final userId = state.extra as String;

//         return EmployeeHomeScreen(userId: userId);
//       },
//     ),
//     GoRoute(
//       path: "/empolyee-attendance",
//       builder: (context, state) => EmployeeAttendanceScreen(),
//     ),
//     GoRoute(
//       path: "/employee-leave",
//       builder: (context, state) => EmployeeLeaveScreen(),
//     ),
//     GoRoute(
//       path: "/manager-home",
//       builder: (context, state) => ManagerHomeScreen(),
//     ),
// GoRoute(
//   path: "/add-empolyees",
//   builder: (context, state) => AddEmployeesScreen(),
// ),
//     GoRoute(
//       path: "/leave-request",
//       builder: (context, state) => LeaveRequestsScreen(),
//     ),

//   ],
// );

import 'package:go_router/go_router.dart';
import 'package:hr_tool/screens/add%20employees/add_employees_screen.dart';
import 'package:hr_tool/screens/attendence/employee_attendence.dart';
import 'package:hr_tool/screens/auth/login_screen.dart';
import 'package:hr_tool/screens/auth/register_screen.dart';
import 'package:hr_tool/screens/home%20screen/employee_home_screen.dart';
import 'package:hr_tool/screens/home%20screen/manager_home_screen.dart';
import 'package:hr_tool/screens/leaves/employee_leave_screen.dart';
import 'package:hr_tool/screens/leaves/leave_requests_screen.dart';
import 'package:hr_tool/screens/profiles/manager_profile_screen.dart';
import 'package:hr_tool/screens/splash_screen.dart';
import 'package:hr_tool/screens/task%20screen/employee_task_screen.dart';
import 'package:hr_tool/screens/task%20screen/manager_add_task_screen.dart';
import 'package:hr_tool/screens/teams/employees_team_members_screen.dart';
import 'package:hr_tool/screens/teams/team_members_screen.dart'
    hide LeaveRequestsScreen;

import 'manager_main_scaffold.dart'; // This will hold bottom nav

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => SplashScreen()),
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: "/add-empolyees",
      builder: (context, state) => AddEmployeesScreen(),
    ),
    GoRoute(
      path: "/employee-home",
      builder: (context, state) {
        final userId = state.extra as String;
        return EmployeeHomeScreen(userId: userId);
      },
    ),
    GoRoute(
      path: "/empolyee-attendance",
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
      path: "/manager-add-task",
      builder: (context, state) => ManagerAddTaskScreen(),
    ),
    GoRoute(
      path: "/employee-task",
      builder: (context, state) => EmployeeTasksScreen(),
    ),

    // ShellRoute for Manager Navigation
    ShellRoute(
      builder: (context, state, child) {
        return ManagerMainScaffold(child: child); // This contains bottom nav
      },
      routes: [
        GoRoute(
          path: "/manager-home",
          builder: (context, state) => ManagerHomeScreen(),
        ),
        GoRoute(
          path: "/team",
          builder: (context, state) => AddEmployeesScreen(), // Placeholder
        ),
        GoRoute(
          path: "/leave-request",
          builder: (context, state) => LeaveRequestsScreen(),
        ),
        GoRoute(
          path: "/profile",
          builder: (context, state) => ManagerProfileScreen(), // Placeholder
        ),
      ],
    ),

    GoRoute(
      path: "/add-empolyees",
      builder: (context, state) => AddEmployeesScreen(),
    ),
  ],
);
