
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;

  String _statusText = "Initializing...";

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthAndNavigate();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
        );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      _textController.forward();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();
    String? savedUserRole = prefs.getString('user_role');
    print("User Role is : $savedUserRole");
    setState(() => _statusText = "Checking authentication...");

    final session = supabase.auth.currentSession;

    // Minimum splash duration
    await Future.delayed(const Duration(seconds: 3));

    if (session == null) {
      
      setState(() => _statusText = "Redirecting to login...");
      await Future.delayed(const Duration(milliseconds: 600));
       context.go('/login');
      return;
    }

    final user = session.user;
    setState(() => _statusText = "Loading profile...");

    try {
      debugPrint("Fetching user with id: ${user.id}");

      if (savedUserRole == null) {
        // No profile found → sign out
        setState(() => _statusText = "Profile not found, signing out...");
        await supabase.auth.signOut();
        await Future.delayed(const Duration(milliseconds: 600));
       context.go('/login');
        return;
      }

      await _navigateBasedOnUserData(savedUserRole);
    } catch (e) {
      debugPrint("Error during splash navigation: $e");
      setState(() => _statusText = "Something went wrong...");
      await Future.delayed(const Duration(milliseconds: 800));
      context.go('/login');
    }
  }

  Future<void> _navigateBasedOnUserData(String role) async {
    if (role == 'manager') {
      setState(() => _statusText = "Welcome back, Manager!");
      await Future.delayed(const Duration(milliseconds: 600));
      context.go('/manager-home');
    } else if (role == 'employee') {
      setState(() => _statusText = "Welcome back Employee!");
      await Future.delayed(const Duration(milliseconds: 600));
      context.go('/employee-home');
    } else {
      // Invalid role
      setState(() => _statusText = "Invalid role, signing out...");
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo
            AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.business_center_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _textAnimation,
                child: Column(
                  children: [
                    Text(
                      'HR Tool',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your workforce efficiently',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Loading + Status
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _statusText,
                    key: ValueKey(_statusText),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Footer
            Text(
              '© 2025 Your Company Name',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
