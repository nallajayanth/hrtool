import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_tool/screens/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6bXhqb2VmamhpeXFoZ2tpY2tnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3NTQ3NTQsImV4cCI6MjA2ODMzMDc1NH0.zaagCfJbonR3CYcfVRagW28cXVgF2Ghp4jGH_qnTwwA',
    url: 'https://vzmxjoefjhiyqhgkickg.supabase.co',
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     routerConfig: appRouter,
    );
  }
}
