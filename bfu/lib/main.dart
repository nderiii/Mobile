import 'package:bfu/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: "https://kqbhhkogartxakpcqgkm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxYmhoa29nYXJ0eGFrcGNxZ2ttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjA0NjIsImV4cCI6MjA3ODkzNjQ2Mn0.JiZXdJ_TLOdvLQ44vZvaXWGvGMfLrZqse5hD26VVWyE",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage());
  }
}
