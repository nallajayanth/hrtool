import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:hr_tool/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  String? selectedRole;
  String? selectedDepartment;

  String mobileError = "";
  String formError = "";
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  final List<String> departments = [
    'HR Department',
    'Instructor Department',
    'Success Coach Department',
  ];

  final List<String> roles = ['Manager', 'Employee'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Screen")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, "Name", "Enter Your Name"),
                const SizedBox(height: 15),
                _buildTextField(emailController, "Email", "Enter Your Email"),
                const SizedBox(height: 15),
                _buildTextField(
                  mobileController,
                  "Mobile Number",
                  "Enter Your Mobile Number",
                  isNumber: true,
                ),
                if (mobileError.isNotEmpty)
                  Text(mobileError, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 15),
                _buildDropdown("Role", roles, selectedRole, (value) {
                  setState(() => selectedRole = value);
                }),
                const SizedBox(height: 15),
                _buildDropdown("Department", departments, selectedDepartment, (
                  value,
                ) {
                  setState(() => selectedDepartment = value);
                }),
                const SizedBox(height: 15),
                _buildTextField(
                  passwordController,
                  "Password",
                  "Enter Your Password",
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  confirmpasswordController,
                  "Confirm Password",
                  "Enter Password Again",
                  isPassword: true,
                ),
                if (formError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      formError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isLoading ? null : validateAndRegister,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      hint: Text("Select $label"),
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(value: item, child: Text(item)),
          )
          .toList(),
    );
  }

  Future<void> validateAndRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmpasswordController.text.trim();

    setState(() {
      mobileError = "";
      formError = "";
      isLoading = true;
    });

    if ([
          name,
          email,
          mobile,
          password,
          confirmPassword,
        ].any((element) => element.isEmpty) ||
        selectedRole == null ||
        selectedDepartment == null) {
      setState(() {
        formError =
            "* Please fill all the fields and select a role and department";
        isLoading = false;
      });
      return;
    }

    if (mobile.length != 10) {
      setState(() {
        mobileError = "* Please check your mobile number";
        isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        formError = "* Passwords do not match";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        await supabase.from('users').insert({
          'id': user.id,
          'email': email,
          'name': name,
          'mobile': mobile,
          'role': selectedRole,
          'department': selectedDepartment,
          'is_approved': selectedRole == 'Manager',
        });

        if (!mounted) return;
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
        context.go("/login");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registered Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      debugPrint("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $error"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
