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

      // Check the error message content for common auth errors
      final msg = e.message.toLowerCase();

      // Check for network/connectivity issues first
      if (msg.contains('socket') ||
          msg.contains('host lookup') ||
          msg.contains('no address') ||
          msg.contains('failed to connect') ||
          msg.contains('network')) {
        errorMessage =
            'Cannot reach server. Please check your internet connection and try again.';
      } else if (msg.contains('already') && msg.contains('registered')) {
        errorMessage = 'This email is already registered';
      } else if (msg.contains('weak') && msg.contains('password')) {
        errorMessage = 'Password is too weak. Please use a stronger password';
      } else if (msg.contains('invalid') && msg.contains('email')) {
        errorMessage = 'Please enter a valid email address';
      } else {
        // Return the original message if no pattern matches
        errorMessage = e.message;
      }

      return AuthResult(success: false, errorMessage: errorMessage);
    } on Exception catch (e) {
      // Check if it's a network-related exception
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socket') ||
          errorStr.contains('host lookup') ||
          errorStr.contains('no address') ||
          errorStr.contains('connection')) {
        return AuthResult(
          success: false,
          errorMessage:
              'Cannot reach server. Please check your internet connection and try again.',
        );
      }

      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
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
      // Debug logging - remove this in production
      print('AuthException caught: ${e.message}');
      print('Status code: ${e.statusCode}');

      // Handle specific Supabase auth errors
      String errorMessage;

      // Check the error message content for common auth errors
      final msg = e.message.toLowerCase();

      // Check for network/connectivity issues first
      if (msg.contains('socket') ||
          msg.contains('host lookup') ||
          msg.contains('no address') ||
          msg.contains('failed to connect') ||
          msg.contains('network')) {
        errorMessage =
            'Cannot reach server. Please check your internet connection and try again.';
      } else if (msg.contains('invalid') ||
          msg.contains('credentials') ||
          msg.contains('password')) {
        errorMessage = 'Invalid email or password';
      } else if (msg.contains('email') &&
          msg.contains('not') &&
          msg.contains('confirmed')) {
        errorMessage = 'Please confirm your email address before logging in';
      } else if (msg.contains('user') &&
          msg.contains('not') &&
          msg.contains('found')) {
        errorMessage = 'No account found with this email';
      } else {
        // Return the original message if no pattern matches
        errorMessage = e.message;
      }

      return AuthResult(success: false, errorMessage: errorMessage);
    } on Exception catch (e) {
      // Debug logging - remove this in production
      print('Exception caught: $e');

      // Check if it's a network-related exception
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socket') ||
          errorStr.contains('host lookup') ||
          errorStr.contains('no address') ||
          errorStr.contains('connection')) {
        return AuthResult(
          success: false,
          errorMessage:
              'Cannot reach server. Please check your internet connection and try again.',
        );
      }

      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      // Debug logging - remove this in production
      print('Unexpected error caught: $e');

      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Reset password - sends email with reset link
  Future<AuthResult> resetPassword(String email) async {
    try {
      // Not specifying redirectTo will use Supabase's default hosted password update page
      // This is a web page that works across all platforms including mobile
      await supabase.auth.resetPasswordForEmail(email);

      return AuthResult(success: true);
    } on AuthException catch (e) {
      // Debug logging - remove this in production
      print('AuthException caught: ${e.message}');
      print('Status code: ${e.statusCode}');

      // Handle specific Supabase auth errors
      String errorMessage;

      // Check the error message content for common auth errors
      final msg = e.message.toLowerCase();

      // Check for network/connectivity issues first
      if (msg.contains('socket') ||
          msg.contains('host lookup') ||
          msg.contains('no address') ||
          msg.contains('failed to connect') ||
          msg.contains('network')) {
        errorMessage =
            'Cannot reach server. Please check your internet connection and try again.';
      } else if (msg.contains('user') &&
          msg.contains('not') &&
          msg.contains('found')) {
        errorMessage = 'No account found with this email address';
      } else if (msg.contains('invalid') && msg.contains('email')) {
        errorMessage = 'Please enter a valid email address';
      } else {
        // Return the original message if no pattern matches
        errorMessage = e.message;
      }

      return AuthResult(success: false, errorMessage: errorMessage);
    } on Exception catch (e) {
      // Debug logging - remove this in production
      print('Exception caught: $e');

      // Check if it's a network-related exception
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socket') ||
          errorStr.contains('host lookup') ||
          errorStr.contains('no address') ||
          errorStr.contains('connection')) {
        return AuthResult(
          success: false,
          errorMessage:
              'Cannot reach server. Please check your internet connection and try again.',
        );
      }

      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      // Debug logging - remove this in production
      print('Unexpected error caught: $e');

      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
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
