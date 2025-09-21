import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient client;
  AuthCubit(this.client) : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        emit(AuthAuthenticated(user: response.user!));
      } else {
        emit(const AuthError("Sign up failed. Please try again."));
      }
    } on AuthException catch (e) {
      emit(AuthError(_mapAuthError(e.message)));
    } catch (e) {
      emit(const AuthError("Something went wrong. Please try again."));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        emit(AuthAuthenticated(user: response.user!));
      } else {
        emit(const AuthError("Login failed. Please check your credentials."));
      }
    } on AuthException catch (e) {
      emit(AuthError(_mapAuthError(e.message)));
    } catch (e) {
      emit(const AuthError("Something went wrong. Please try again."));
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
    emit(AuthInitial());
  }

  /// 🔹 Map Supabase errors to user-friendly messages
  String _mapAuthError(String message) {
    final msg = message.toLowerCase();
    if (msg.contains("invalid login credentials")) {
      return "The email or password is incorrect.";
    } else if (msg.contains("email not confirmed")) {
      return "Please verify your email before logging in.";
    } else if (msg.contains("password")) {
      return "Password must be at least 6 characters.";
    } else {
      return message; // fallback to original
    }
  }
}
