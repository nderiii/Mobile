import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bfu/pages/dashboard.dart';
import 'package:bfu/pages/loginpage.dart';
import 'package:bfu/services/supabase_apis.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: "https://kqbhhkogartxakpcqgkm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxYmhoa29nYXJ0eGFrcGNxZ2ttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjA0NjIsImV4cCI6MjA3ODkzNjQ2Mn0.JiZXdJ_TLOdvLQ44vZvaXWGvGMfLrZqse5hD26VVWyE",
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Small delay to ensure Supabase is fully initialized
    await Future.delayed(const Duration(milliseconds: 100));

    final loggedIn = SupabaseApis().isUserLoggedIn();

    setState(() {
      isLoggedIn = loggedIn;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SafeArea(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      home: isLoggedIn ? const DashboardPage() : const Loginpage(),
    );
  }
}
