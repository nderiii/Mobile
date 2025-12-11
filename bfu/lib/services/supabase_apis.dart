import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;

  AuthResult({required this.success, this.errorMessage, this.user});
}

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
  Future<AuthResult> createUser(
    String email,
    String password,
    String confirmPassword, {
    String? username,
  }) async {
    try {
      if (password != confirmPassword) {
        return AuthResult(
          success: false,
          errorMessage: 'Passwords do not match',
        );
      }

      // Sign up with email and password
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );

      if (res.user != null) {
        return AuthResult(success: true, user: res.user);
      }

      return AuthResult(
        success: false,
        errorMessage: 'Registration failed. Please try again.',
      );
    } on AuthException catch (e) {
      // Handle specific Supabase auth errors
      String errorMessage;
      switch (e.statusCode) {
        case '422':
        case 'email_exists':
          errorMessage = 'This email is already registered';
          break;
        case 'weak_password':
          errorMessage = 'Password is too weak. Please use a stronger password';
          break;
        case 'invalid_email':
          errorMessage = 'Please enter a valid email address';
          break;
        default:
          errorMessage = e.message;
      }

      return AuthResult(success: false, errorMessage: errorMessage);
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign in existing user
  Future<AuthResult> signIUser(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        return AuthResult(success: true, user: res.user);
      }

      return AuthResult(
        success: false,
        errorMessage: 'Login failed. Please try again.',
      );
    } on AuthException catch (e) {
      // Handle specific Supabase auth errors
      String errorMessage;
      switch (e.statusCode) {
        case 'invalid_credentials':
        case '400':
          errorMessage = 'Invalid email or password';
          break;
        case 'email_not_confirmed':
          errorMessage = 'Please confirm your email address before logging in';
          break;
        case 'user_not_found':
          errorMessage = 'No account found with this email';
          break;
        default:
          errorMessage = e.message;
      }

      return AuthResult(success: false, errorMessage: errorMessage);
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // Sign out current user
  Future<void> signOutUser() async {
    await supabase.auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  // Get current session
  Session? getCurrentSession() {
    return supabase.auth.currentSession;
  }
}
