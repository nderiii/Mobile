import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApis {
  final supabase = Supabase.instance.client;
  // instance of dio client
  Dio? dio;

  SupabaseApis() {
    dio = Dio(BaseOptions(baseUrl: ""));
  }

  Future init() async {
    // supabase in
    // stance
  }

  // create a new user account
  Future<AuthResponse> createUser(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    final res = await supabase.auth.signUp(email: email, password: password);

    final Session? session = res.session;
    final User? user = res.user;

    return res;
  }

  Future<void> signIUser(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future sessionHandler() async {
    return supabase.auth.currentSession;
  }
}
