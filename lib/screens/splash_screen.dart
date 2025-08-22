// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hr_tool/riverpod/user_details/model/user_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration(seconds: 3), () async {
//       final user = Supabase.instance.client.auth.currentUser;
//       final supabase = Supabase.instance.client;
//       final userData = await supabase
//           .from('users')
//           .select()
//           .eq('id', user!.id)
//           .single();
//       final appUser = UserModel.fromMap(userData);
//       if (user != null) {
//         if (appUser.role == "Manager") {
//           context.go("/manager-home");
//           print("Hi manager");
//         } else {
//           context.go(
//             "/employee-home",
//             extra: Supabase.instance.client.auth.currentUser!.id,
//           );
//           print("Hi empluee");
//         }
//       } else {
//         context.go("/login");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text("HI all")));
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hr_tool/riverpod/user_details/model/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final supabase = Supabase.instance.client;

    // Delay to simulate splash
    await Future.delayed(const Duration(seconds: 2));

    final user = supabase.auth.currentUser;

    if (user == null) {
      context.go('/login');
      return;
    }

    try {
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle(); // Safe: returns null if no match

      if (userData == null) {
        // User exists in auth, but no data in 'users' table
        await supabase.auth.signOut();
        context.go('/login');
        return;
      }

      final appUser = UserModel.fromMap(userData);

      if (appUser.role == 'Manager') {
        context.go('/manager-home');
      } else if (appUser.role == 'Employee') {
        context.go('/employee-home', extra: user.id);
      } else {
        // Unknown role
        await supabase.auth.signOut();
        context.go('/login');
      }
    } catch (e) {
      debugPrint('Error during splash navigation: $e');
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
