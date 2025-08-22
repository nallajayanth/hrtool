// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hr_tool/riverpod/user_details/model/user_model.dart';
// // import 'package:hr_tool/screens/auth/register_screen.dart';
// // import 'package:hr_tool/screens/home%20screen/employee_home_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool isLoading = false;
//   final supabase = Supabase.instance.client;

//   Future<void> loginUser() async {
//     setState(() => isLoading = true);

//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     try {
//       final response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       final user = response.user;
//       if (response.user != null) {
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => EmployeeHomeScreen(userId: response.user!.id),
//         //   ),
//         // );
//         final userData = await supabase
//             .from('users')
//             .select()
//             .eq('id', user!.id)
//             .single();
//         final appUser = UserModel.fromMap(userData);
//         print(appUser.role);

//         if (appUser.role == "Manager") {
//           context.go("/manager-home", extra: response.user!.id);
//         } else {
//           print("Hi");
//           context.go("/employee-home", extra: response.user!.id);
//         }
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.message)));
//     } catch (_) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Unexpected error occurred")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text("Login Screen", style: TextStyle(color: Colors.red)),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: emailController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   hintText: "Enter Your Email",
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   labelStyle: const TextStyle(color: Colors.white),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   hintText: "Enter Your Password",
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   labelStyle: const TextStyle(color: Colors.white),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: loginUser,
//                       child: const Text("Login"),
//                     ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have an account?",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   const SizedBox(width: 6),
//                   TextButton(
//                     onPressed: () => context.push("/register"),
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(builder: (_) => const RegisterScreen()),
//                     // )
//                     child: const Text(
//                       "Sign Up",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hr_tool/riverpod/user_details/provider/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final supabase = Supabase.instance.client;

    try {
      // 1. Authenticate user
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. If login is successful, fetch user data via provider
      final userDetails = await ref.read(userProviderProvider.future);
      final user = userDetails.first;

      // 3. Navigate based on role
      if (user.role.toLowerCase() == 'manager') {
        context.go("/manager-home");
      } else {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const EmployeeHomeScreen()),
        // );
        context.go("/employee-home", extra: response.user!.id);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () => context.push("/register"), child:Text("Register "))
          ],
        ),
      ),
    );
  }
}
